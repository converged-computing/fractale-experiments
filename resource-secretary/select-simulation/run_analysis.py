import argparse
import asyncio
import random
import json
import os
import time
import math
from pathlib import Path
from typing import Any, Dict, List

import pandas as pd
import numpy as np
from rich.console import Console
from rich.progress import Progress

from resource_secretary.agents.secretary import SecretaryAgent
from resource_secretary.algorithm.select import get_selector, STRATEGIES
from resource_secretary.algorithm.select.base import (
    SelectionResult,
    SelectionStatus,
    WorkerProposal,
    WorkerVerdict,
)
import resource_secretary.utils as utils
from dataclasses import dataclass, asdict

here = os.path.abspath(os.path.dirname(__file__))

# Helper agent to update responses to remove opinion and keep facts
agent = SecretaryAgent()

console = Console()

PRICING = {
    "hpc": {"node": 0.65, "cpu": 0.015, "gpu": 0.16},
    "cloud": {"node": 1.50, "cpu": 0.080, "gpu": 1.49},
    "standalone": {"node": 0.12, "cpu": 0.010, "gpu": 0.44},
}


@dataclass
class Worker:
    worker_id: str
    archetype: str
    total_cores: int
    total_gpus: int
    total_nodes: int
    available_nodes: int
    available_cores: int
    cores_per_node: int
    gpus_per_node: int
    available_gpus: int
    queue_depth: int
    pricing: float
    truth: Any

    def is_busy(self) -> bool:
        """
        Returns True if the worker utilization is 95% or higher.
        """
        return (self.available_nodes / self.total_nodes) < 0.95


def clean_proposal(response):
    """
    Use an agent to clean bias. This does, however, report what the agent found (or think it found)
    """
    content = (
        "You are a bias removing agent. Your job is to take the agentic response below and "
        + "summarize ONLY the facts. Do not include any state (e.g., BUSY/READY or compatibility assessment).\n"
        + "You MUST NOT include information about counts for the queue to indicate busyness - they are old\n"
        + "You MUST NOT include anything that you cannot determine\n"
        + "If the result was INCOMPATIBLE do NOT include information about what was not found, as it might be incorrect.\n"
        + "You MUST ONLY include factual statements.\n'"
        + response
    )
    result = agent.backend.generate_response([{"content": content}])
    return (
        "\nCLUSTER AGENT opinion (results may not be accurate):\n"
        + result.candidates[0].content.parts[0].text
    )


def shuffle_proposals(proposals):
    keys = list(proposals.keys())
    values = list(proposals.values())
    random.shuffle(values)
    return dict(zip(keys, values))

def unknown_result(reason):
    return SelectionResult(
        worker_id=None,
        status=SelectionStatus("UNKNOWN"),
        reasoning=reason,
    )


def backup_proposal(response):
    return "\nCLUSTER AGENT opinion (results may not be accurate):\n" + response


class SimulationState:
    def __init__(self):
        self.fleet = {}

    def initialize_worker(
        self, worker_id: str, baseline_data: Dict[str, Any], reset_queue=False
    ):
        """
        Parse into worker object, primarily to interact with metadata and truth.
        """
        gt = baseline_data["ground_truth"]["truth"]
        arch = baseline_data["ground_truth"]["metadata"]["archetype"]
        manager = None
        for found_manager in ["slurm", "flux", "kubernetes", "machine"]:
            if found_manager in gt["workload"]:
                manager = found_manager
                break

        # Stuff we are interested in
        total_nodes = gt["workload"][manager]["total_nodes"]
        total_cores = gt["workload"][manager]["total_cores"]
        idle_nodes = gt["workload"][manager]["idle_nodes"]
        idle_cores = gt["workload"][manager]["idle_cores"]
        cores_per_node = gt["workload"][manager]["cores_per_node"]
        gpus_per_node = gt["hardware"]["hardware"]["gpu"]["count"]

        queue_depth = total_nodes - idle_nodes
        total_gpus = idle_nodes * gpus_per_node
        if reset_queue:
            queue_depth = 0
            total_gpus = total_nodes * gpus_per_node
            idle_nodes = total_nodes
            idle_cores = total_cores

        # We are assuming starting at a specific state
        self.fleet[worker_id] = Worker(
            worker_id=worker_id,
            archetype=arch,
            total_cores=total_cores,
            total_nodes=total_nodes,
            total_gpus=total_gpus,
            available_cores=idle_cores,
            cores_per_node=cores_per_node,
            # Assume N gpus per node idle
            available_gpus=idle_nodes * gpus_per_node,
            gpus_per_node=gpus_per_node,
            available_nodes=idle_nodes,
            # We will use this to provide prompt about resource
            truth=gt,
            # We can't distinguish between running and queued
            # If there is a queue depth, utilization of the rest is 100%
            queue_depth=queue_depth,
            pricing=PRICING[arch],
        )

    def calculate_exclusive_nodes(self, w, comp):
        """
        Given logic.compute, get exclusive nodes.

        We get the max nodes considering GPU/CPU requests.
        """
        count = comp["count"]
        p = w.pricing

        if comp["unit"] == "nodes":
            nodes_needed_for_cpu = count

        # If we have cpus, we still need to consider nodes
        else:  # core count / how many cores per node
            nodes_needed_for_cpu = math.ceil(comp["count"] / w.cores_per_node)

        # GPU request is consistent (can be 0) across requests
        nodes_needed_for_gpu = 0
        if w.gpus_per_node > 0:
            nodes_needed_for_gpu = math.ceil(comp["gpus"] / w.gpus_per_node)
        return max(nodes_needed_for_cpu, nodes_needed_for_gpu)

    def calculate_cost(self, worker_id: str, logic: Dict[str, Any]) -> float:
        """
        We cannot calculate cost if we do not know resources.
        We can't estimate and get it very wrong (and then it's an easy choice).
        """
        w = self.fleet[worker_id]
        p = w.pricing
        comp = logic.get("compute", {})

        # We do not know and cannot know- the selector will not consider None values.
        cost = None
        if not comp:
            return cost

        # We assume exclusive nodes, so we need to calculate the minimum number of nodes for this
        # This does not account for optimal shape.
        nodes_needed = self.calculate_exclusive_nodes(w, comp)
        cost = comp["count"] * p["node"] * nodes_needed

        # The AND/OR is relevant for all, but we only need to give the lower price
        # for the deterministic algorithms. E.g., we assume they cannot decide on the fly
        # For the agent, we won't give the calculated cost in the prompt, we will give the prices
        # for it to "think" over. :)
        # For OR cases for the deterministic ones, we consider AND because they cannot determine an OR.
        return cost

    def update_resources(self, worker_id: str, logic: Dict[str, Any]):
        worker = self.fleet[worker_id]
        worker.queue_depth += 1
        if "compute" not in logic:
            return

        nodes_needed = self.calculate_exclusive_nodes(worker, logic["compute"])
        # Even if we don't need GPU, if we use the node, we take the GPUs
        worker.available_gpus -= nodes_needed * worker.gpus_per_node
        worker.available_nodes -= nodes_needed
        worker.available_cores -= nodes_needed * worker.cores_per_node
        self.fleet[worker_id] = worker

    def add_worker_truth(self, wid):
        """
        Add worker truth. This is the level of granularity we know about a cluster,
        high level like manager, etc.
        """
        worker = self.fleet[wid]
        resources = {}

        manager = ""
        if "workload" in worker.truth:
            resources["workload"] = list(worker.truth["workload"].keys())[0]

        for key in ["storage", "network", "container", "software", "parallel"]:
            if key not in worker.truth:
                continue
            resources[key] = ", ".join(list(worker.truth[key].keys()))

        truth = "ACTUAL CLUSTER PROVIDERS:"
        for provider, line in resources.items():
            truth += f"\n{provider}: {line}"
        return truth

    def add_cluster_cost(self, wid) -> str:
        """
        This is primarily used by the agent.
        """
        worker = self.fleet[wid]
        return (
            "\nCURRENT COST:\n"
            + f"Type: {worker.archetype},"
            + f" Per Node ${worker.pricing['node']}, Per CPU ${worker.pricing['cpu']}, Per GPU ${worker.pricing}['gpu']"
        )

    def add_cluster_status(self, wid) -> str:
        """
        This is primarily used by the agent.
        """
        worker = self.fleet[wid]
        return (
            "\nCURRENT STATUS:\n"
            + f"Type: {worker.archetype}, {worker.available_cores} cores free, "
            + f"{worker.available_gpus} GPUs free. Queue depth: {worker.queue_depth}. "
            + f"cluster busy (> 95% nodes used) is: {worker.is_busy()}"
        )


def load_prompts(jobs_dir: Path) -> Dict[str, Any]:
    all_prompts = {}
    for batch_file in jobs_dir.glob("batch-*.json"):
        all_prompts.update(utils.read_json(batch_file))
    return all_prompts


def run_experiment(args):
    data_dir = Path(args.data_dir)
    jobs_dir = Path(os.path.join(args.data_dir, "jobs"))
    prompts_metadata = load_prompts(jobs_dir)
    with_truth = args.with_truth
    experiment_iter = args.iter
    without_state = args.without_state
    print(
        f"Iteration: {experiment_iter} with truth ({with_truth}) without state ({without_state}) reset queue {args.reset_queue}"
    )

    # We want to start with ALL strategies, but make custom agentic to have cost OR queue, depending on context
    strategies = args.strategies
    summary = {}

    # agentic will be considered a base. cost will add cost metrics for node/gpu
    # Since most heuristics DO consider state (e.g., BUSY) we will give the agent that.
    strategies += ["agentic-cost"]

    # For each strategy, we will do one iteration across all workers, with comparison to the agent
    for strategy in args.strategies:
        console.print(f"\n[bold green]▶ Running Strategy: {strategy}[/bold green]")
        summary[strategy] = {}
        results = []

        # Reset state for each strategy run
        # We only need one file here to get the worker's state (which does not change)
        # I probably should refactor first experiment to save it once!
        state = SimulationState()
        worker_ids = [
            d.name for d in data_dir.iterdir() if d.is_dir() and "jobs" not in str(d)
        ]

        for worker_folder in (data_dir).iterdir():
            if not worker_folder.is_dir() or "jobs" in str(worker_folder):
                continue
            with open(worker_folder / "result-0.json") as f:
                state.initialize_worker(
                    worker_folder.name, json.load(f), reset_queue=args.reset_queue
                )

        # If we have a scoped agent (to know about cost, same agent
        if "agentic-cost" in strategy:
            selector = get_selector(["agentic"])
        else:
            selector = get_selector([strategy])

        # Randomly shuffle proposals
        p_ids = sorted(prompts_metadata.keys(), key=int)
        random.shuffle(p_ids)

        # Keep track of prompts that we could not satisfy anywhere
        prompts_zero_across_workers = set()

        with Progress() as progress:
            task = progress.add_task(
                f"[cyan]Processing {strategy}...", total=len(p_ids)
            )

            # One set of proposals is one prompt ACROSS workers
            for pid in p_ids:
                proposals = {}
                contender_workers = 0
                summary[strategy][pid] = {"BUSY": 0, "READY": 0}
                for wid in state.fleet.keys():
                    job = prompts_metadata[pid]
                    logic = job["logic"]
                    res_path = data_dir / wid / f"result-{pid}.json"
                    if not res_path.exists():
                        continue
                    res_data = utils.read_json(res_path)
                    contender_workers += 1

                    # We only are interested in clusters for which we can run the work ACTUALLY
                    # and the agent determined it too.
                    actual_verdict = res_data["audit"]["verdict"]["actual_verdict"]
                    if actual_verdict in ["INCOMPATIBLE", "UNKNOWN"]:
                        continue

                    # For selection algorithms, we consider BUSY > 80% utilization
                    # give this to the deterministic approaches directly.
                    actual_verdict = (
                        "BUSY" if state.fleet[wid].is_busy() else actual_verdict
                    )

                    # Assume COMPATIBLE is READY since not busy
                    actual_verdict = (
                        "READY" if actual_verdict == "COMPATIBLE" else actual_verdict
                    )
                    summary[strategy][pid][actual_verdict] += 1

                    # Important! The proposal is tweaked for the agent depending on
                    # the algorithm policy we are comparing to. We don't want to bias
                    # the agent with cost data for its "base" case
                    proposal = res_data["audit"]["report"]["response"]
                    if "agent" in strategy:
                        proposal += state.add_worker_truth(wid)
                        if with_truth:
                            try:
                                proposal += clean_proposal(
                                    res_data["audit"]["report"]["response"]
                                )
                            except Exception as e:
                                # This is a Google 503 error - it's pretty rare.
                                proposal += backup_proposal(
                                    res_data["audit"]["report"]["response"]
                                )
                                print(e)

                    # Always add queue state to give the agent
                    prompt = job["prompt"]
                    if "agentic" in strategy:
                        proposal += state.add_cluster_status(wid)
                    if strategy == "agentic-cost":
                        proposal += state.add_cluster_cost(wid)
                        prompt += ". I must consider and minimize cost"

                    proposals[wid] = {
                        # The agent just sees the proposal, not hard coded metrics
                        "data": {"proposal": proposal},
                        # Extra metrics are not "seen" by any algorithm.
                        # The agent only sees the proposal we give it.
                        "metrics": {
                            "queue_depth": state.fleet[wid].queue_depth,
                            "total_cost": state.calculate_cost(wid, logic),
                            "available_cores": state.fleet[wid].available_cores,
                        },
                        "actual_verdict": actual_verdict,
                    }

                # This is after we have parsed all workers
                # This is for debugging.
                # print(f"Prompt {pid} has {len(proposals)} valid proposals across {contender_workers} workers.")
                if not proposals:
                    prompts_zero_across_workers.add(pid)
                    continue

                # This is after the proposals loop
                start_ts = time.perf_counter()
                try:
                    selection = asyncio.run(selector.select(prompt, proposals))
                except Exception as e:
                    selecion = unknown_result(f"Issue Gemini API: {e}")

                latency = time.perf_counter() - start_ts
                if selection.status == SelectionStatus.SELECTED:

                    # Note if we get a match and don't KNOW the resources, we cannot update nodes.
                    # but we CAN add 1 to queue depth.
                    if not without_state:
                        state.update_resources(selection.worker_id, logic)

                    # We need this to be flat for data frame
                    proposals = shuffle_proposals(proposals)
                    try:
                        cost = proposals[selection.worker_id]["metrics"]["total_cost"]
                    except:
                        cost = None
                    result = {
                        "strategy": strategy,
                        "prompt_id": pid,
                        "worker": selection.worker_id,
                        "cost": cost,
                        "latency": latency,
                        "reasoning": selection.reasoning,
                        "actual_verdict": proposals[selection.worker_id][
                            "actual_verdict"
                        ],
                        "status": "SUCCESS",
                        "selection_status": str(selection.status),
                        "contenders": len(proposals),
                    }
                    summary[strategy][pid]["selected"] = result
                    for key, val in asdict(state.fleet[selection.worker_id]).items():
                        # This is a more nested object, do not use
                        if key == "truth":
                            continue
                        if isinstance(val, dict):
                            for k, v in val.items():
                                result[f"worker_{key}_{k}"] = v
                        else:
                            result[f"worker_{key}"] = val
                    results.append(result)
                else:
                    result = {
                        "strategy": strategy,
                        "reasoning": selection.reasoning,
                        "prompt_id": pid,
                        "status": "REJECTED",
                        "selection_status": str(selection.status),
                        "latency": latency,
                        "contenders": len(proposals),
                    }
                    results.append(result)

            progress.update(task, advance=1)

        console.print(f"Strategy {strategy} is complete.")
        df = pd.DataFrame(results)
        outdir = os.path.join(args.outdir, experiment_iter, strategy)
        if not os.path.exists(outdir):
            os.makedirs(outdir)
        df.to_csv(os.path.join(outdir, "selection-results.csv"))
        final_results = {"results": results, "summary": summary[strategy]}
        utils.write_json(final_results, os.path.join(outdir, "selection-results.json"))

    utils.write_json(
        summary, os.path.join(args.outdir, experiment_iter, "selection-summary.json")
    )
    console.print(
        f"\n[bold green]✔ Experiment Complete. Results saved to {args.outdir}[/bold green]"
    )


def main():
    parser = argparse.ArgumentParser(
        description="Resource Secretary Selection Experiment"
    )
    parser.add_argument(
        "--data-dir",
        type=str,
        required=True,
        help="Path to worker data",
        default="../negotiate-simulation/data/1",
    )
    parser.add_argument(
        "--strategies",
        nargs="+",
        default=list(STRATEGIES.keys()),
        help="List of selection strategies to test",
    )
    parser.add_argument(
        "--without-state",
        action="store_true",
        default=False,
        help="Run simulation without state",
    )
    parser.add_argument(
        "--with-truth",
        action="store_true",
        default=False,
        help="Add agent cleaned response (takes much longer)",
    )
    parser.add_argument(
        "--reset-queue",
        action="store_true",
        default=False,
        help="Reset queue depth to 0",
    )
    parser.add_argument(
        "--outdir",
        type=str,
        default=os.path.join(here, "results"),
        help="Output directory",
    )
    parser.add_argument(
        "--iter",
        default="0",
        help="iteration or subdirectory for each experiment",
    )

    args = parser.parse_args()
    console.print(f"Preparing to test {args.strategies}")
    run_experiment(args)


if __name__ == "__main__":
    main()
