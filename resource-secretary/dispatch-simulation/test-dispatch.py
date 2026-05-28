import argparse
import sys
import asyncio
import json
import time
import os
import re
import itertools
from pathlib import Path
import subprocess

from fastmcp import Client
from rich import print
from rich.console import Console
from rich.progress import (
    BarColumn,
    MofNCompleteColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
)
from rich.table import Table

from flux.job.output import JobOutputWatchLines
from resource_secretary.apps import get_application
import resource_secretary.utils as utils

console = Console()

# We will only ask agent to submit, verify success,
# and we need to monitor, etc.
from flux.job.watcher import JobWatcher
import flux.job
import flux


class SetEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, set):
            return list(obj)
        return super().default(obj)


async def get_workers_truth(url):
    async with Client(url) as hub:
        return await hub.call_tool("export_fleet_truth", {})


import time


def fetch_job_logs(handle, jobid, timeout_seconds=300):
    """
    Watches job output with a hard wall-clock timeout.
    I added this because there are rare cases when we might
    wait forever.

    Returns:
        tuple: (list_of_lines, did_timeout)
    """
    watcher = JobOutputWatchLines(handle, jobid)
    lines = []
    start_time = time.time()
    did_timeout = False

    while True:
        if (time.time() - start_time) > timeout_seconds:
            did_timeout = True
            break
        stream, line = watcher.getline()
        if stream is None:
            break
        formatted_line = f"[{stream}] {line.strip()}"
        print(formatted_line)
        lines.append(line)

    return lines, did_timeout


async def run_one(hub, handle, item, output_dir, worker_id, args):
    """
    Allow for failure!
    """
    max_duration = args.max_duration
    with_expectation = args.with_expectation
    with_validate = args.with_validate
    timeout_seconds = args.log_timeout

    # generate a uid for the combination (unique)
    uid = re.sub("(:|-)", "-", item["prompt_style"]).replace("|", "_")
    output_file = os.path.join(output_dir, f"{uid}.json")
    if os.path.exists(output_file):
        return

    # Tell the LLM where lammps is - we already know from previous work this is important
    prompt_text = item["prompt"]
    print(prompt_text)
    prompt_text += f"\nThe lmp binary is in /usr/local/bin. The data is in /opt/lammps-reax. Do NOT specify a queue. Set a max duration of {max_duration}."

    # These are the same and could be simplified, but I want to be specific
    if with_expectation:
        prompt_text += with_expectation
    if with_validate:
        prompt_text += with_validate

    # Hub (dispatch_job) -> Worker (submit)
    start = time.time()
    response = await hub.call_tool(
        "dispatch_job", {"prompt": prompt_text, "worker_id": worker_id}
    )
    end = time.time()

    print(response)
    data = getattr(response, "structured_content", None)
    print(data)
    if not data:
        data = json.loads(response.content[0].text)

    result = {
        "prompt": prompt_text,
        "response": data,
        "worker_id": worker_id,
        "output": None,
        "item": item,
        "dispatch_job_time_seconds": end - start,
        "status": "UNKNOWN",
        "reason": "This should not happen",
    }
    receipt = data.get("receipt")

    # Case 1: agent did not follow instruction to provide a recipe
    if not receipt:
        result.update({"status": "FAILED", "reason": "Missing receipt"})
        utils.write_json(result, output_file)
        return

    # Case 2: agent did not provide a job id
    job_id = receipt.get("job_id")
    if not job_id:
        result.update({"status": "FAILED", "reason": "Missing job_id in receipt"})
        utils.write_json(result, output_file)
        return

    # Case 3: Job id is invalid
    try:
        jobid = flux.job.JobID(job_id)
    except Exception as e:
        result.update({"status": "FAILED", "reason": f"Cannot parse job_id: {e}"})
        utils.write_json(result, output_file)
        return

    # Case 4: Job id is (probably) hallucinated
    try:
        job_info = flux.job.get_job(handle, jobid)
    except Exception as e:
        result.update({"status": "FAILED", "reason": f"Cannot get job_id: {e}"})
        utils.write_json(result, output_file)
        return

    # Add the job info to save
    result["job_info"] = job_info
    log_lines, timed_out = fetch_job_logs(
        handle, jobid, timeout_seconds=timeout_seconds
    )
    result["output"] = log_lines
    utils.write_json(result, output_file)

    # Update with finished job info
    try:
        job_info = flux.job.get_job(handle, jobid)
        result["job_info"] = job_info
    except Exception as e:
        pass

    # Status, timeout on getting logs or success
    status = "TIMEOUT" if timed_out else "SUCCESS"

    # calls are here
    # response.structured_content['receipt']['calls']
    # result['response']['receipt']['calls']
    # At this point we have logs, jobid, and info, can delete
    try:
        purged = handle.rpc(
            "job-manager.purge",
            payload='{"age_limit":0.0,"num_limit":-1,"batch":50,"force":true}',
        ).get()
        result.update({"total_submit": purged.get("count")})
    except Exception as e:
        result.update(
            {
                "status": "SUCCESS",
                "reason": f"Job succeeded, purge failed (no count)",
            }
        )
        utils.write_json(result, output_file)
        return

    result.update({"status": status, "reason": f"Job succeeded."})
    utils.write_json(result, output_file)


async def run_simulation(matrix, args):
    """
    Main Orchestrator for the Resource Secretary Dispatch Experiments!

    Unlike negotiate/select, we don't need to randomly generate the prompts. We have
    a pre-determined set that we need to carefully run and collect data for.
    """
    url = args.url
    output_dir = Path(args.outdir)

    handle = flux.Flux()
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    async with Client(url) as hub:

        # Get our one experiment worker.
        truth_response = await get_workers_truth(url)
        truth = json.loads(truth_response.content[0].text)
        worker_id = list(truth["ground_truth"].keys())[0]
        print(f"Discovered single worker {worker_id}")
        print(truth_response)

        for item in matrix:
            try:
                await run_one(hub, handle, item, output_dir, worker_id, args)
            except Exception as e:
                print(f"Issue running {item}: {e}")

    console.print(f"\n💾 Delegation results saved to [blue]{output_dir}[/blue]")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--url", default="http://localhost:8089/mcp", help="Hub MCP URL"
    )
    parser.add_argument(
        "--outdir", default="dispatch-results", help="Output directory to save results"
    )
    parser.add_argument("--count", help="Count of prompts to generate")

    # These are set to defaults for our experiment
    parser.add_argument("--tasks", type=int, help="Number of tasks", default=320)
    parser.add_argument("--nodes", type=int, help="Number of tasks", default=5)
    parser.add_argument("-x", type=int, help="Lammps x parameter", default=32)
    parser.add_argument("-y", type=int, help="Lammps y parameter", default=32)
    parser.add_argument("-z", type=int, help="Lammps z parameter", default=16)
    parser.add_argument(
        "--max-duration",
        help="Maximum duration in flux standard time (str)",
        default="1m",
    )
    parser.add_argument("--with-expectation", help="Give the LLM an expectation")
    parser.add_argument("--with-validate", help="Ask agent to validate lammps args")
    parser.add_argument(
        "--log-timeout", type=int, help="Log wait timeout in seconds", default=300
    )
    args = parser.parse_args()

    console.print(f"\n🚀 [bold cyan]Starting Resource Secretary Simulation[/bold cyan]")
    console.print(f"📡 Target Hub: [blue]{args.url}[/blue]")
    if args.count:
        console.print(f"📊 Prompt Count: {args.count}\n")

    lammps = get_application("lammps")
    matrix = lammps.get_prompt_matrix(
        nodes=args.nodes,
        tasks=args.tasks,
        flatten=True,
        count=args.count,
        x=args.x,
        y=args.y,
        z=args.z,
    )

    # Let's peek at the sizes
    print(f"With expectation: {args.with_expectation}")
    print(f"Generated {len(matrix)} prompts.")
    asyncio.run(run_simulation(matrix, args))
