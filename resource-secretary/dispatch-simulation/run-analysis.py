import os
import json
import glob
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import argparse
import re
import shlex

from itertools import combinations
import statsmodels.api as sm
import statsmodels.formula.api as smf

from collections import Counter
from scipy.stats import fisher_exact, chi2_contingency

here = os.path.dirname(os.path.abspath(__file__))



def analyze_direction(df):
    # Ensure job_success is binary
    df["job_success"] = [1 if x > 0 else 0 for x in df.wall_time]

    # Extract variants as before
    def get_variants(uid):
        clean_uid = uid.split("_", 1)[-1]
        return {p: 1 for p in clean_uid.split("|")}

    variants_df = df["uid"].apply(get_variants).apply(pd.Series).fillna(0)

    print(f"{'Variant':35} | p-value | Odds Ratio | Impact")
    print("-" * 75)

    for variant in variants_df.columns:
        # Create 2x2 table: [[Success_with, Fail_with], [Success_without, Fail_without]]
        with_var = df[variants_df[variant] == 1]["job_success"]
        without_var = df[variants_df[variant] == 0]["job_success"]

        table = [
            [sum(with_var == 1), sum(with_var == 0)],
            [sum(without_var == 1), sum(without_var == 0)],
        ]

        # Fisher exact gives the p-value and the Odds Ratio
        odds_ratio, p_value = fisher_exact(table)

        if p_value < 0.05:
            direction = "Success Driver" if odds_ratio > 1 else "Failure Trigger"
            sig = "*"
        else:
            direction = "Neutral"
            sig = ""

        print(f"{variant:35} | {p_value:.4f}{sig} | {odds_ratio:.2f} | {direction}")


def analyze_component_styles(df):
    # 1. Extract every key:value pair into a dictionary
    def get_variants(uid):
        # Remove index (e.g., '1_') and split
        clean_uid = uid.split("_", 1)[-1]
        return {p: 1 for p in clean_uid.split("|")}

    # 2. Create binary columns for every specific combination
    # e.g., 'manager:descriptive', 'manager:exact', etc.
    variants_df = df["uid"].apply(get_variants).apply(pd.Series).fillna(0)

    # Add success target
    full_df = pd.concat([variants_df, df["job_success"]], axis=1)

    print(f"\n{'Specific Prompt Variant':35} | p-value")
    print("-" * 50)

    for variant in variants_df.columns:
        # Create 2x2 table: (Variant Present/Absent) vs (Job Success/Failure)
        contingency = pd.crosstab(full_df[variant], full_df["job_success"])

        if contingency.size > 1:
            chi2, p, _, _ = chi2_contingency(contingency)
            sig = "*" if p < 0.05 else ""
            print(f"{variant:35} | {p:.4f} {sig}")


def parse_style(uid):
    # Remove leading index (e.g., '1_') and split by pipe
    clean_uid = uid.split("_", 1)[-1]
    parts = clean_uid.split("|")
    # Create a dictionary of {component: style}
    return {p.split(":")[0]: p.split(":")[1] for p in parts if ":" in p}
    


class DispatchSimulationAnalyzer:
    def __init__(self, results_dir, outdir):
        self.results_dir = results_dir
        self.outdir = outdir
        self.records = []
        self.error_logs = {}
        self.affinity_values = {}
        self.env_vars = {}

    def parse_style(self, style_str):
        """
        Parses prompt style features into a dictionary.
        """
        features = {}
        # Splitting by common separators used in these experiment naming conventions
        parts = re.split(r"[|_]", style_str)
        for part in parts:
            if ":" in part:
                k, v = part.split(":", 1)
                features[f"feat_{k}"] = v
        return features

    def get_lammps_stats(self, output_lines):
        """
        Parses LAMMPS log for citations and wall time.
        """
        text = "\n".join(output_lines)
        # If the citation block is present, the agent failed to suppress it
        has_citation = (
            "Please cite the original paper" in text or "Citing LAMMPS" in text
        )

        wall_seconds = 0
        wall_time_match = re.search(r"Total wall time: (\d+):(\d+):(\d+)", text)
        if wall_time_match:
            h, m, s = map(int, wall_time_match.groups())
            wall_seconds = h * 3600 + m * 60 + s

        return has_citation, wall_seconds

    def analyze_calls(self, calls_list):
        """
        Detailed breakdown of tool call counts.
        """
        counts = Counter([c.get("function") for c in calls_list])
        return dict(counts)

    def extract_last_submit_args(self, calls_list):
        """
        Retrieves arguments from the final submit_job call.
        """
        for call in reversed(calls_list):
            if call.get("function") == "submit_job":
                return call.get("args", {})
        return {}

    def process_data(self):
        """
        Process all data files. The path and iteration is a uid.
        """
        file_paths = glob.glob(
            os.path.join(self.results_dir, "**/*.json"), recursive=True
        )
        print(f"Analyzing {len(file_paths)} result files...")

        extra_args = {}

        # Look at 0 wall times - what happened?
        noruns = []
        known_args_counts = {}
        for path in file_paths:
            with open(path, "r") as f:
                try:
                    data = json.load(f)
                except json.JSONDecodeError:
                    continue
                if "pod" in path or "nodes" in path:
                    continue
                iteration = path.split(os.sep)[-3]
                experiment = "agentic"
                prompt_style = data.get("item", {}).get("prompt_style", "unknown")

                if experiment not in self.affinity_values:
                    self.affinity_values[experiment] = Counter()
                    self.env_vars[experiment] = Counter()
                    self.error_logs[experiment] = Counter()

                # Tool Call Analysis
                calls_raw = (
                    data.get("response", {}).get("receipt", {}).get("calls", "[]")
                )
                try:
                    calls = json.loads(calls_raw)
                except:
                    calls = []

                # Uses counter to get the function name.
                call_counts = self.analyze_calls(calls)

                # Agent final effort is LAST submit_job
                # This does not include Flux args, just lammps. E.g.,
                # /usr/local/bin/lmp -v x 2 -v y 2 -v z 2 -in in.reaxff.hns -nocite
                submit_args = self.extract_last_submit_args(calls)
                agent_command = submit_args.get("command", "") or ""

                # These will be for non runs
                run_command = ""
                full_path = None

                if not agent_command:
                    raise ValueError("THIS SHOULD NOT HAPPEN")
                else:
                    run_command = "flux submit"
                    known_args = {
                        "num_nodes": "-N",
                        "num_tasks": "-n",
                        "cores_per_task": "--cores-per-task",
                        "gpus_per_task": "--gpus-per-task",
                        "duration": "--duration",
                        "cwd": "--cwd",
                        "cpu_affinity": "-o cpu-affinity",
                        "output": "--out",
                        "error": "--err",
                        "unbuffered": "--unbuffered",
                        "environment": "--env",
                        "gpu_affinity": "-o gpu-affinity",
                        "bank": "--bank",
                        "label_io": "--label-io",
                        "exclusive": "--exclusive",
                        "queue": "--queue",
                        "env_expand": "",
                        "input": "--input",
                        "rlimits": "--rlimit",
                    }
                    agent_args = set(submit_args)
                    agent_args.remove("command")
                    prefixes = list(known_args)
                    while prefixes:
                        arg = prefixes.pop(0)
                        if arg not in submit_args:
                            continue
                        if arg not in known_args_counts:
                            known_args_counts[arg] = 0
                        known_args_counts[arg] += 1
                        agent_arg = submit_args.get(arg)
                        agent_args.remove(arg)
                        if (
                            agent_arg is not None
                            and arg == "environment"
                            and arg != "{"
                        ):
                            if isinstance(agent_arg, str):
                                try:
                                    agent_arg = json.loads(agent_arg)
                                except:
                                    continue
                            for k, v in agent_arg.items():
                                run_command += f"--env {k}={v}"
                        # Supported by sdk, not flux submit command line
                        elif agent_arg in ["env_expand", "label_io", "exclusive"]:
                            continue
                        # Booleans
                        elif agent_arg is not None and arg in ["unbuffered"]:
                            run_command += f" {known_args[arg]}"
                        elif agent_arg is not None:
                            run_command += f" {known_args[arg]} {agent_arg}"
                    run_command += " " + submit_args["command"]
                    if agent_args:
                        for arg in agent_args:
                            if experiment not in extra_args:
                                extra_args[experiment] = {}
                            if arg not in extra_args[experiment]:
                                extra_args[experiment][arg] = 0
                            extra_args[experiment][arg] += 1

                # Number of times agent gave full path
                full_path = 1 if "/usr/bin" in run_command else 0

                # GPU/Affinity should NOT be a thing.
                gpu_asked = 0
                if submit_args.get("gpu_affinity") or "gpu" in agent_command.lower():
                    gpu_asked = 1

                aff = submit_args.get("cpu_affinity")
                if aff:
                    self.affinity_values[experiment][str(aff)] += 1

                # Environment Variable Parsing
                envs = submit_args.get("environment") or {}
                if isinstance(envs, str) and envs.startswith("{"):
                    try:
                        envs = json.loads(envs)
                    except:
                        pass

                if envs:
                    print(envs)
                if isinstance(envs, dict):
                    for k in envs.keys():
                        self.env_vars[experiment][k] += 1

                # Resource Validation (Ground Truth vs Agent Tool Args)
                gt = data.get("item", {}).get("ground_truth_params", {})
                command = data["item"]["command"]

                # Check for -v x, y, z in the command string
                # We will check these against what they should be.
                cmd_tokens = shlex.split(agent_command) if agent_command else []
                x_val = (
                    cmd_tokens[cmd_tokens.index("x") + 1] if "x" in cmd_tokens else None
                )
                y_val = (
                    cmd_tokens[cmd_tokens.index("y") + 1] if "y" in cmd_tokens else None
                )
                z_val = (
                    cmd_tokens[cmd_tokens.index("z") + 1] if "z" in cmd_tokens else None
                )

                # LAMMPS log, failures, citations.
                lines = data.get("output") or []
                has_cite, wall_time = self.get_lammps_stats(lines)
                if data.get("status") == "FAILED":
                    # No explicit reason is a timeout
                    error_msg = data["response"]["receipt"].get("error") or "TIMEOUT"
                    self.error_logs[experiment][error_msg] += 1

                # Timings
                info = data.get("job_info", {})
                if wall_time == 0:
                    noruns.append(lines)
                t_submit = info.get("t_submit", 0)
                t_cleanup = info.get("t_cleanup", 0)
                t_run = info.get("t_run", 0)

                # Assemble Record
                record = {
                    "uid": f"{iteration}_{prompt_style}",
                    "path": path,
                    # This is agent success - did it submit and report back
                    "success": 1 if data.get("status") == "SUCCESS" else 0,
                    # This is job success
                    "job_success": 1 if info.get("success") else 0,
                    "submit_count": call_counts.get("submit_job", 0),
                    "info_count": call_counts.get("get_job_info", 0),
                    "logs_count": call_counts.get("get_job_logs", 0),
                    "cancel_count": call_counts.get("cancel_job", 0),
                    "validate_count": call_counts.get("validate_lmp_problem_size", 0),
                    "error_reason": data["reason"],
                    "reasoning": data["response"]["receipt"]["reasoning"],
                    "total_calls": len(calls),
                    "full_path": full_path,
                    "extra_args": extra_args or None,
                    "agent_full_command": run_command,
                    "queue_hallucinated": 1 if submit_args.get("queue") else 0,
                    "gpu_hallucinated": gpu_asked,
                    "node_mismatch": (
                        1 if submit_args.get("num_nodes") != gt.get("nodes") else 0
                    ),
                    "v_vars_mismatch": (
                        1
                        if not (
                            str(x_val) == str(gt.get("x"))
                            and str(y_val) == str(gt.get("y"))
                        )
                        else 0
                    ),
                    "citation_error": 1 if has_cite else 0,
                    "wall_time": wall_time,
                    "experiment": experiment,
                    "command": command,
                    "total_submit": data.get("total_submit"),
                    "manager_overhead": t_cleanup - t_submit if t_submit else 0,
                    "active_runtime": t_cleanup - t_run if t_run else 0,
                    **self.parse_style(prompt_style),
                }
                for arg, value in submit_args.items():
                    record[f"agent_{arg}"] = value

                # Add any unexpected tool calls as columns
                for func_name, count in call_counts.items():
                    if func_name not in [
                        "submit_job",
                        "get_job_info",
                        "get_job_logs",
                        "validate_lmp_problem_size",
                    ]:
                        record[f"extra_tool_{func_name}"] = count

                self.records.append(record)

        print("\n--- Extra Arguments ---")
        for experiment, args in extra_args.items():
            print(f"\n--- Extra Args for {experiment}")
            for val, count in args.items():
                print(f"- {val}: {count}")

        # This is where to get manual "gold standard" runs.
        file_paths = glob.glob(
            os.path.join(here, "results", "lammps-reax", "**/*.out"), recursive=True
        )
        iteration = 0
        for path in file_paths:
            if "lammps-reax-5-" not in path:
                continue
            with open(path, "r") as fd:
                data = fd.read()
            has_cite, wall_time = self.get_lammps_stats(data.split("\n"))
            record = {
                "uid": f"{iteration}_manual",
                "path": path,
                # This is agent success - did it submit and report back
                "success": 1,
                # This is job success
                "job_success": 1,
                "wall_time": wall_time,
                "experiment": "manual",
            }
            self.records.append(record)

        self.df = pd.DataFrame(self.records).fillna(0)

    def run_stats(self):
        """
        Stats for a dinosaur.
        """
        print("\n=== Feature Significance Analysis (Success Correlation) ===")
        # these are like, manager, resources, config, nocite, affinity
        style_cols = [c for c in self.df.columns if c.startswith("feat_")]
        # Filter down to those with success
        self.df.job_success = [1 if x != 0 else 0 for x in self.df.wall_time]
        # Remove manual
        self.df = self.df[self.df.experiment != "manual"]
        for col in style_cols:
            contingency = pd.crosstab(self.df[col], self.df["job_success"])
            if contingency.size > 1:
                chi2, p, _, _ = chi2_contingency(contingency)
                print(f"Factor: {col:30} | p-value: {p:.4f} {'*' if p < 0.05 else ''}")

        analyze_component_styles(self.df)
        analyze_direction(self.df)
        run_logistic_regression(self.df)

    def create_plots(self):
        """
        Plots for a Coastersaurus.
        """
        sns.set_theme(style="whitegrid")
        os.makedirs(self.outdir, exist_ok=True)
        self._plot_tool_fidelity()
        self._plot_prompt_features()
        self._plot_integrity_and_timing()
        self._plot_unexpected_tools()
        # TODO plot total submit (job tries)
        # TODO look at failures and determine why (e.g., job timeout)
        # we need to assess the "successful" that we waited for, for example, and timed out.

    def _plot_unexpected_tools(self):
        """
        Frequency of tools called that were NOT in the allowed spec."""
        # Find columns created for tools outside the 'Big 3'
        extra_tool_cols = [c for c in self.df.columns if c.startswith("extra_tool_")]
        extra_tool_cols = [
            x for x in extra_tool_cols if x not in ["extra_tool_function"]
        ]

        if not extra_tool_cols:
            print("No unexpected tool calls were detected in this dataset.")
            return

        # Sum the total attempts for each unexpected tool
        unexpected_data = self.df[extra_tool_cols].sum().reset_index()
        unexpected_data.columns = ["Tool Name", "Total Call Frequency"]

        # Clean up the names (e.g., 'extra_tool_list_jobs' -> 'list_jobs')
        unexpected_data["Tool Name"] = unexpected_data["Tool Name"].str.replace(
            "extra_tool_", ""
        )

        plt.figure(figsize=(13, 5))
        ax = sns.barplot(
            data=unexpected_data.sort_values(
                by="Total Call Frequency", ascending=False
            ),
            x="Tool Name",
            y="Total Call Frequency",
            palette="autumn",
        )

        plt.title("Unexpected Tool Calls", fontsize=14)
        plt.xlabel("Tool Function Name", fontsize=12)
        plt.ylabel("Total Count of Attempts", fontsize=12)
        plt.xticks(rotation=70)

        # Add integer labels on top of the bars
        for p in ax.patches:
            ax.annotate(
                int(p.get_height()),
                (p.get_x() + p.get_width() / 2.0, p.get_height()),
                ha="center",
                va="center",
                xytext=(0, 7),
                textcoords="offset points",
                fontweight="bold",
            )

        save_path = os.path.join(self.outdir, "unexpected_tool_calls.svg")
        plt.savefig(save_path, bbox_inches="tight")
        save_path = os.path.join(self.outdir, "unexpected_tool_calls.png")
        plt.savefig(save_path, bbox_inches="tight")
        plt.close()
        print(f"Saved: {save_path}")

    def _plot_tool_fidelity(self):
        """
        Analysis of tool call counts vs expectations.
        """
        plt.figure(figsize=(10, 6))
        subset = self.df[self.df.experiment == "agentic"]

        # Rename columns for the plot
        call_df = subset[
            ["submit_count", "info_count", "logs_count", "validate_count", "experiment"]
        ].rename(
            columns={
                "submit_count": "Job Submissions",
                "info_count": "Status Checks",
                "logs_count": "Log Retrievals",
                "validate_count": "Validate Params",
            }
        )
        melted_calls = call_df.melt(
            id_vars="experiment",
            var_name="Tool Function",
            value_name="Average Number of Calls",
        )
        ax = sns.barplot(
            melted_calls,
            x="Tool Function",
            y="Average Number of Calls",
            #            hue='experiment',
            errorbar="sd",
            palette="viridis",
        )

        ax.axhline(1, color="red", linestyle="--", linewidth=2, label="Expected (1.0)")

        # plt.title("Tool Call Redundancy", fontsize=14)
        plt.xlabel("Tool Function", fontsize=14)
        plt.ylabel("Average Number of Calls", fontsize=14)
        # plt.xticks(rotation=45)
        plt.legend()

        save_path = os.path.join(self.outdir, "dispatch_tool_calls.svg")
        plt.savefig(save_path, bbox_inches="tight")
        save_path = os.path.join(self.outdir, "dispatch_tool_calls.pdf")
        plt.savefig(save_path, bbox_inches="tight")
        plt.close()
        print(f"Saved: {save_path}")

        # Let's do a boxplot too.
        plt.figure(figsize=(10, 6))
        ax = sns.boxplot(
            melted_calls,
            x="Tool Function",
            y="Average Number of Calls",
            hue="experiment",
            palette="viridis",
        )
        ax.axhline(1, color="red", linestyle="--", linewidth=2, label="Expected (1.0)")
        plt.title("Tool Call Redundancy", fontsize=14)
        plt.xlabel("Tool Function", fontsize=12)
        plt.ylabel("Average Number of Calls", fontsize=12)
        plt.xticks(rotation=45)
        plt.legend()

        save_path = os.path.join(self.outdir, "dispatch_tool_calls_boxplot.png")
        plt.savefig(save_path, bbox_inches="tight")
        plt.close()
        print(f"Saved: {save_path}")

    def _plot_prompt_features(self):
        """
        Plot 2: Success rate broken down by prompt style features.
        """
        # Find all feature columns (feat_manager, feat_resources, etc)
        feat_cols = [c for c in self.df.columns if c.startswith("feat_")]

        if not feat_cols:
            print("No features found to plot.")
            return

        # Prepare data: Melt features into a long format for comparison
        melted_feat = self.df.melt(
            id_vars=["success"],
            value_vars=feat_cols,
            var_name="Feature_Type",
            value_name="Style_Option",
        )

        # Clean up labels (e.g., 'feat_manager' -> 'Manager')
        melted_feat["Feature_Type"] = (
            melted_feat["Feature_Type"].str.replace("feat_", "").str.capitalize()
        )

        plt.figure(figsize=(12, 7))
        ax = sns.barplot(
            data=melted_feat, x="Feature_Type", y="success", hue="Style_Option"
        )

        plt.title("Impact of Prompt Style on Success Rate", fontsize=14)
        plt.xlabel("Prompt Feature Category", fontsize=12)
        plt.ylabel("Success Rate (Percentage)", fontsize=12)
        plt.ylim(0, 1.1)

        # Add percentage labels on top of bars
        for p in ax.patches:
            if p.get_height() > 0:
                ax.annotate(
                    format(p.get_height(), ".1%"),
                    (p.get_x() + p.get_width() / 2.0, p.get_height()),
                    ha="center",
                    va="center",
                    xytext=(0, 9),
                    textcoords="offset points",
                    fontsize=9,
                )

        save_path = os.path.join(self.outdir, "prompt_feature_analysis.png")
        plt.savefig(save_path, bbox_inches="tight")
        plt.close()
        print(f"Saved: {save_path}")

    def _plot_integrity_and_timing(self):
        fig, ax2 = plt.subplots(1, 1, figsize=(8, 5))
        df = self.df

        # Left: Constraint Violations (Bar)
        h_cols = {
            "queue_hallucinated": "Queue Asked For",
            "gpu_hallucinated": "GPU Parameter Provided",
            "node_mismatch": "Wrong Node Count",
            "citation_error": "Citation Present",
        }
        h_data = df[list(h_cols.keys())].rename(columns=h_cols).sum().reset_index()
        h_data.columns = ["Violation Type", "Total Occurrences"]

        # sns.barplot(data=h_data, x='Violation Type', y='Total Occurrences', ax=ax1, palette="flare")
        # ax1.set_title("Instruction & Constraint Violations", fontsize=13)
        # ax1.tick_params(axis='x', rotation=30)
        # ax1.set_ylabel("Count of Failures", fontsize=11)

        pattern = [x.split("_", 1)[-1] for x in self.df.uid.tolist()]
        subset = df[df.success == 1]
        subset["pattern"] = [x.split("_", 1)[-1] for x in subset.uid.tolist()]
        sns.boxplot(
            data=subset,
            y="wall_time",
            x="experiment",
            ax=ax2,
            palette="Set2",
            hue="experiment",
        )
        ax2.set_title(f"Workload Execution Timing", fontsize=13)
        ax2.set_xlabel("Wall time (Seconds)", fontsize=11)
        ax2.set_ylabel("Count", fontsize=11)

        plt.tight_layout()
        save_path = os.path.join(self.outdir, f"wall_time_args.svg")
        plt.savefig(save_path)
        save_path = os.path.join(self.outdir, f"wall_time_args.png")
        plt.savefig(save_path)
        plt.close()
        print(f"Saved: {save_path}")

    def print_summary(self):
        print("\n" + "=" * 50)
        print("Summary")
        print("=" * 50)
        print(f"Total Experiments:   {len(self.df)}")
        print(f"Overall Success:      {self.df['success'].mean():.2%}")
        print(
            f"Success by Experiment:      {self.df.groupby('experiment').success.mean()}"
        )
        print(
            f"Total Citations Found: {self.df.groupby('experiment').citation_error.sum()} (Failed to suppress)"
        )
        print(
            f"Forbidden Queue Asked: {self.df.groupby('experiment').queue_hallucinated.sum()}"
        )
        print(
            f"GPU Hallucinations:   {self.df.groupby('experiment').gpu_hallucinated.sum()}"
        )

        print("\n--- Unique Affinity Values Requested ---")
        for experiment, counts in self.affinity_values.items():
            print(f"\n--- Affinity for {experiment}")
            for val, count in counts.items():
                print(f"- {val}: {count}")

        print("\n--- Environment Variables Set ---")
        for experiment, counts in self.env_vars.items():
            print(f"\n--- Environment for {experiment}")
            for val, count in counts.items():
                print(f"- {val}: {count}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Analyze Gemini Flux Simulation Results"
    )
    parser.add_argument(
        "--dir",
        type=str,
        help="Directory containing numeric iteration folders",
        default=os.path.join(here, "dispatch-results", "5-node-validate"),
    )
    parser.add_argument(
        "--outdir",
        type=str,
        help="Output directory",
        default=os.path.join(here, "results", "img"),
    )
    args = parser.parse_args()
    analyzer = DispatchSimulationAnalyzer(args.dir, args.outdir)
    analyzer.process_data()
    analyzer.print_summary()
    analyzer.create_plots()
    analyzer.run_stats()
