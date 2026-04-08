import os
import json
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import argparse
from pathlib import Path
from scipy.stats import mannwhitneyu

# ==========================================
# Data Processing & Stats
# ==========================================


def parse_all_results(input_dirs):
    all_rows = []
    count = 0
    for input_root in input_dirs:
        base = Path(input_root)
        if not base.exists():
            continue
        for exp_dir in base.iterdir():
            if not exp_dir.is_dir() or exp_dir.name.startswith("."):
                continue
            for strategy_dir in exp_dir.iterdir():
                if not strategy_dir.is_dir():
                    continue
                json_path = strategy_dir / "selection-results.json"
                if not json_path.exists():
                    continue
                with open(json_path, "r") as f:
                    data = json.load(f).get("results", [])
                    for res in data:
                        count += 1
                        archetype = res.get("worker_archetype")
                        if not archetype:
                            continue
                        all_rows.append(
                            {
                                "strategy": strategy_dir.name,
                                "experiment": json_path.parts[1],
                                "prompt_id": res.get("prompt_id"),
                                "status": res.get("status"),
                                "is_success": (
                                    1 if res.get("status") == "SUCCESS" else 0
                                ),
                                "latency": res.get("latency", 0),
                                "cost": (
                                    res.get("cost")
                                    if res.get("cost") is not None
                                    else 0.0
                                ),
                                "worker_id": res.get("worker_worker_id"),
                                "archetype": archetype,
                                "q_depth": res.get("worker_queue_depth", 0),
                                "avail_cores": res.get("worker_available_cores", 0),
                                "avail_gpus": res.get("worker_available_gpus", 0),
                                "pricing_node": res.get("worker_pricing_node", 0),
                                "pricing_gpu": res.get("worker_pricing_gpu", 0),
                                "contenders": res.get("contenders", 0),
                            }
                        )
    df = pd.DataFrame(all_rows)
    print(f"Total experiments: {count}, Total selected: {df.shape}")
    return df


def report_decision_overhead(df, heuristic_baseline="queue-depth"):
    """
    Reports the 'Reasoning Tax': How much slower is the Agent
    than a standard script?
    """
    print("\n" + "=" * 80)
    print(f"{'DECISION OVERHEAD ANALYSIS (The Reasoning Tax)':^80}")
    print("=" * 80)
    print(
        f"{'Strategy':<20} | {'Decision Time (s)':<18} | {'Overhead (x)':<12} | {'p-value'}"
    )
    print("-" * 80)

    # Get baseline speed (usually ~0.001s)
    base_latency = df[df["strategy"] == heuristic_baseline]["latency"].mean()
    if base_latency == 0:
        base_latency = 0.000001  # Prevent div by zero

    for strategy in sorted(df["strategy"].unique()):
        strat_data = df[df["strategy"] == strategy]["latency"]
        m_latency = strat_data.mean()

        # How many times slower is this than the script?
        multiplier = m_latency / base_latency

        # Statistical Significance
        _, p = mannwhitneyu(
            strat_data,
            df[df["strategy"] == heuristic_baseline]["latency"],
            alternative="greater",
        )

        p_str = f"{p:.4e}" if p < 0.001 else f"{p:.4f}"

        print(f"{strategy:<20} | {m_latency:<18.3f} | {multiplier:<12.1f} | {p_str}")

    print("-" * 80)
    print(f"Baseline Heuristic: {heuristic_baseline}")
    print("=" * 80)


def report_latency_statistics(df, baseline_strategy="queue-depth"):
    """
    Prints a formal statistical report of decision latency differences
    between Agentic strategies and traditional heuristics.
    """
    print("\n" + "=" * 80)
    print(f"{'LATENCY STATISTICAL REPORT (Baseline: ' + baseline_strategy + ')':^80}")
    print("=" * 80)
    print(
        f"{'Strategy':<20} | {'Mean (s)':<10} | {'Median (s)':<10} | {'StdDev':<8} | {'Delta (s)':<10} | {'p-value'}"
    )
    print("-" * 80)

    # Filter for successful selections only (since failed latency might differ)
    success_df = df[df["is_success"] == 1]

    # Get baseline data
    if baseline_strategy not in success_df["strategy"].unique():
        print(f"Error: Baseline {baseline_strategy} not found in successful results.")
        return

    base_data = success_df[success_df["strategy"] == baseline_strategy]["latency"]
    base_mean = base_data.mean()

    # Iterate through all other strategies
    for strategy in sorted(success_df["strategy"].unique()):
        strat_data = success_df[success_df["strategy"] == strategy]["latency"]

        # Calculate Stats
        m_mean = strat_data.mean()
        m_median = strat_data.median()
        m_std = strat_data.std()
        delta = m_mean - base_mean

        # Statistical Test (Mann-Whitney U is preferred for latency distributions)
        # Testing if strategy latency is greater than baseline
        stat, p = mannwhitneyu(strat_data, base_data, alternative="greater")

        # Formatting p-value
        p_str = f"{p:.4e}" if p < 0.001 else f"{p:.4f}"
        if p < 0.01:
            p_str += " (*)"

        print(
            f"{strategy:<20} | {m_mean:<10.3f} | {m_median:<10.3f} | {m_std:<8.3f} | {delta:<10.3f} | {p_str}"
        )

    print("-" * 80)
    print("(*) Indicates statistical significance (p < 0.01)")
    print("=" * 80)


# To use this in your main() function:
# report_latency_statistics(df, baseline_strategy='queue-depth')


def calculate_advanced_metrics(df):
    if df.empty:
        return df
    df["is_success"] = (df["is_success"]).astype(int)
    df["prompt_id_int"] = pd.to_numeric(df["prompt_id"], errors="coerce")

    # Regret Index
    success_only = df[df["is_success"] == 1]
    if not success_only.empty:
        best_per_prompt = success_only.groupby("prompt_id")["q_depth"].transform("min")
        # Map regret back to main dataframe
        df.loc[df["is_success"] == 1, "regret"] = (
            success_only["q_depth"] - best_per_prompt
        )
    else:
        df["regret"] = 0

    # Idle Waste
    df["idle_gpu_waste_cost"] = df["avail_gpus"].clip(lower=0) * df["pricing_gpu"]
    return df


# ==========================================
# Visualization Functions
# ==========================================


def plot_agreement_matrix(df, output_path):
    try:
        pivot_df = df.pivot_table(
            index=["prompt_id"], columns="strategy", values="worker_id", aggfunc="first"
        )
        strategies = pivot_df.columns
        agreement_matrix = pd.DataFrame(
            index=strategies, columns=strategies, dtype=float
        )
        for s1 in strategies:
            for s2 in strategies:
                both_active = pivot_df[s1].notna() & pivot_df[s2].notna()
                if both_active.sum() == 0:
                    agreement_matrix.loc[s1, s2] = 0.0
                else:
                    matches = (
                        pivot_df.loc[both_active, s1] == pivot_df.loc[both_active, s2]
                    )
                    agreement_matrix.loc[s1, s2] = matches.mean()

        plt.figure(figsize=(12, 10))
        sns.heatmap(agreement_matrix, annot=True, cmap="YlGnBu", fmt=".2f")
        plt.title("Agreement: Probability of picking the same worker")
        plt.ylabel("")
        plt.xlabel("")
        plt.tight_layout()
        plt.savefig(os.path.join(output_path, "agreement.svg"))
    except Exception as e:
        print(f"Could not generate agreement matrix: {e}")


def plot_archetype_performance(df, output_path):
    success_df = df[df["is_success"] == 1].copy()
    if success_df.empty:
        return

    arch_means = success_df.groupby("archetype")["cost"].transform("mean")
    success_df["normalized_cost"] = success_df["cost"] / arch_means
    depth_means = success_df.groupby("archetype")["q_depth"].transform("mean")
    success_df["normalized_depth"] = success_df["q_depth"] / depth_means

    # Normalized Cost
    plt.figure(figsize=(9, 7))
    sns.barplot(data=success_df, x="archetype", y="normalized_cost", hue="strategy")
    plt.axhline(1.0, ls="--", color="red", alpha=0.5, label="Archetype Avg")
    plt.title("Cost Efficiency (Relative to Archetype Average)")
    plt.ylabel("Relative Cost (1.0 = Average)")
    plt.legend()
    plt.tight_layout()
    plt.savefig(os.path.join(output_path, "normalized-archetype.svg"))
    plt.close()

    # Normalized Depth
    plt.figure(figsize=(9, 7))
    sns.boxplot(data=success_df, x="archetype", y="normalized_depth", hue="strategy")
    plt.title("Queue Depth (Relative to Archetype Average)")
    plt.ylabel("Depth (1.0 = Average)")
    plt.tight_layout()
    plt.savefig(os.path.join(output_path, "normalized-q-depth.svg"))
    plt.close()


def plot_state_evolution(df, output_path):
    plt.figure(figsize=(12, 6))
    df_sorted = df[df["is_success"] == 1].sort_values("prompt_id_int")
    sns.lineplot(
        data=df_sorted,
        x="prompt_id_int",
        y="q_depth",
        hue="strategy",
        style="archetype",
    )
    plt.title("Evolution of Selected Cluster Queue Depth over Time")
    plt.savefig(os.path.join(output_path, "evolution.svg"))
    plt.close()


def plot_fleet_pressure(df, output_path):
    """
    Calculates: (Total Successful Placements) / (Total Unique Slots in Fleet)
    This creates a smooth, linearly increasing line showing system saturation.
    """
    plt.figure(figsize=(12, 6))
    df = df.sort_values(["archetype", "strategy", "prompt_id_int"])
    df = df[df.archetype == "hpc"]

    # 1. Total Fleet Capacity (Unique workers * their cores/slots)
    # We estimate capacity by looking at the max cores reported for every unique worker_id
    fleet_capacity = df.groupby("worker_id")["avail_cores"].max().sum()

    # 2. Cumulative Workload (Jobs placed so far)
    # Each success adds 1 unit of pressure to the system
    for (source, strat), group in df.groupby(["archetype", "strategy"]):
        group = group.sort_values("prompt_id_int")
        group["cumulative_load"] = group["is_success"].cumsum()

        # Pressure = Load / Capacity (Normalized 0 to 1)
        # If capacity is unknown, we just plot the cumulative count
        plt.plot(
            group["prompt_id_int"],
            group["cumulative_load"],
            label=f"{strat} ({source})",
        )

    plt.title("Pressure: System Saturation Over Time")
    plt.ylabel("Cumulative Tasks")
    plt.xlabel("Prompt Sequence (Time)")
    plt.legend(bbox_to_anchor=(1.05, 1), loc="upper left")
    plt.tight_layout()
    plt.savefig(os.path.join(output_path, "pressure.svg"))
    print("Fleet Pressure plot saved.")


def plot_specific_worker_trajectories(df, output_path, top_n=5):
    """
    Fixes the 'jumping' issue by isolating specific worker IDs.
    This shows how the queue of Worker A, Worker B, etc., grows over time.
    """
    plt.figure(figsize=(12, 6))

    # We focus on the 'agentic' strategy in the 'reset-depth' source
    focus_df = df[
        (df["strategy"] == "agentic")
        & (df["archetype"] == "reset-depth")
        & (df["is_success"] == 1)
    ].copy()

    if focus_df.empty:
        print("No successful agentic reset-depth data for trajectories.")
        return

    # Find the IDs of the workers used most frequently
    top_worker_ids = focus_df["worker_id"].value_counts().nlargest(top_n).index

    for wid in top_worker_ids:
        worker_data = focus_df[focus_df["worker_id"] == wid].sort_values(
            "prompt_id_int"
        )
        # Calculate the GROWTH of the queue for this specific worker
        worker_data["local_queue_growth"] = range(1, len(worker_data) + 1)

        plt.step(
            worker_data["prompt_id_int"],
            worker_data["local_queue_growth"],
            where="post",
            label=f"Worker {wid}",
        )

    plt.title(f"Monotonic Load Growth for Top {top_n} Selected Workers")
    plt.ylabel("Cumulative Jobs Assigned to Worker")
    plt.xlabel("Prompt Sequence (Time)")
    plt.legend()
    plt.savefig(os.path.join(output_path, "worker_trajectories.svg"))
    print("Worker Trajectories plot saved.")


def plot_rejection_analysis(df, output_path):
    success_strategies = ["queue-depth", "soonest", "run-anytime"]
    heuristic_success_ids = df[
        (df["strategy"].isin(success_strategies)) & (df["is_success"] == 1)
    ]["prompt_id"].unique()
    agent_rejections = df[
        (df["strategy"] == "agentic")
        & (df["status"] == "REJECTED")
        & (df["prompt_id"].isin(heuristic_success_ids))
    ]
    if len(agent_rejections) > 0:
        plt.figure(figsize=(10, 6))
        sns.countplot(data=agent_rejections, x="strategy", hue="archetype")
        plt.title(
            "Strategic Rejections: Jobs accepted by heuristics but rejected by Agent"
        )
        plt.savefig(os.path.join(output_path, "rejections.svg"))
        plt.close()


def plot_cost_efficiency(df, output_path):
    plt.figure(figsize=(10, 6))
    summary = (
        df.groupby(["strategy", "archetype"])
        .agg({"is_success": "mean", "cost": "mean"})
        .reset_index()
    )
    sns.scatterplot(
        data=summary, x="cost", y="is_success", hue="strategy", s=200, style="archetype"
    )
    plt.title("The Cost-Feasibility Pareto Frontier")
    plt.savefig(os.path.join(output_path, "cost_efficiency.svg"))
    plt.close()


def plot_selectivity(df, output_path):
    plt.figure(figsize=(10, 6))
    success_df = df[df["is_success"] == 1]
    if not success_df.empty:
        sns.scatterplot(data=success_df, x="contenders", y="q_depth", hue="strategy")
        plt.title("Impact of Choice Volume on Selection Quality")
        plt.savefig(os.path.join(output_path, "selectivity.svg"))
        plt.close()


def plot_enabling_power(df, output_path):
    plt.figure(figsize=(10, 6))
    summary = (
        df.groupby(["strategy", "archetype"])
        .agg({"is_success": "mean", "latency": "mean"})
        .reset_index()
    )
    sns.scatterplot(
        data=summary,
        x="latency",
        y="is_success",
        hue="strategy",
        s=200,
        style="archetype",
    )
    plt.title("The 'Reasoning Tax': Latency vs. Feasibility")
    plt.savefig(os.path.join(output_path, "feasibility.svg"))
    plt.close()


def plot_constraint_hardness(df, output_path):
    plt.figure(figsize=(10, 6))
    df["contender_bins"] = pd.cut(df["contenders"], bins=[0, 1, 5, 10, 20, 50, 100])
    sns.barplot(data=df, x="contender_bins", y="is_success", hue="strategy")
    plt.title("Agent Robustness vs. Constraint Hardness")
    plt.savefig(os.path.join(output_path, "hardness.svg"))
    plt.close()


def plot_resource_slack(df, output_path):
    plt.figure(figsize=(10, 6))
    sns.boxenplot(
        data=df[df["is_success"] == 1], x="strategy", y="avail_cores", hue="archetype"
    )
    plt.title("Resource Slack: Idle Cores on Chosen Workers")
    plt.savefig(os.path.join(output_path, "slack.svg"))
    plt.close()


def plot_cumulative_workload_growth(df, output_path):
    plt.figure(figsize=(12, 6))
    df_sorted = df.sort_values(["archetype", "strategy", "prompt_id_int"])
    df_sorted["cumulative_jobs"] = df_sorted.groupby(["archetype", "strategy"])[
        "is_success"
    ].cumsum()
    sns.lineplot(
        data=df_sorted,
        x="prompt_id_int",
        y="cumulative_jobs",
        hue="strategy",
        style="archetype",
    )
    plt.title("System Saturation: Cumulative Task Placement")
    plt.savefig(os.path.join(output_path, "saturation.svg"))
    plt.close()


def plot_top_worker_evolution(df, output_path, top_n=5):
    plt.figure(figsize=(12, 6))
    focus_df = df[(df["is_success"] == 1) & (df["strategy"] == "agentic")].copy()
    if not focus_df.empty:
        top_workers = focus_df["worker_id"].value_counts().nlargest(top_n).index
        subset = (
            focus_df[focus_df["worker_id"].isin(top_workers)]
            .copy()
            .sort_values("prompt_id_int")
        )
        subset["worker_load"] = subset.groupby("worker_id").cumcount() + 1
        sns.lineplot(
            data=subset, x="prompt_id_int", y="worker_load", hue="worker_id", marker="o"
        )
        plt.title(f"Individual Worker Load Growth (Top {top_n})")
        plt.savefig(os.path.join(output_path, "worker_growth.svg"))
        plt.close()


def run_stats(df, baseline_strategy):
    print("\n" + "=" * 50)
    print(f"STATISTICAL ANALYSIS (Baseline: {baseline_strategy})")
    print("=" * 50)
    target = "agentic"
    if (
        target in df["strategy"].unique()
        and baseline_strategy in df["strategy"].unique()
    ):
        success_df = df[df["is_success"] == 1]
        for metric in ["q_depth", "cost", "latency"]:
            t_data = success_df[success_df["strategy"] == target][metric]
            b_data = success_df[success_df["strategy"] == baseline_strategy][metric]
            if len(t_data) > 1 and len(b_data) > 1:
                stat, p = mannwhitneyu(t_data, b_data)
                print(f"{metric:10} | p-value: {p:.4f}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input_dirs", nargs="+")
    parser.add_argument("-o", "--output-csv", default="analysis_results.csv")
    parser.add_argument("--output", required=True)
    parser.add_argument("-b", "--baseline", default="random")
    parser.add_argument("-v", "--verbose", action="store_true")
    args = parser.parse_args()

    os.makedirs(args.output, exist_ok=True)
    df = parse_all_results(args.input_dirs)
    if df.empty:
        print("No data found.")
        return

    df = calculate_advanced_metrics(df)

    # Execute all plotting functions
    plot_agreement_matrix(df, args.output)
    plot_archetype_performance(df, args.output)
    plot_state_evolution(df, args.output)
    plot_rejection_analysis(df, args.output)
    plot_cost_efficiency(df, args.output)
    plot_selectivity(df, args.output)
    plot_enabling_power(df, args.output)
    plot_constraint_hardness(df, args.output)
    plot_resource_slack(df, args.output)
    plot_cumulative_workload_growth(df, args.output)
    plot_top_worker_evolution(df, args.output)
    plot_specific_worker_trajectories(df, args.output, top_n=5)
    plot_fleet_pressure(df, args.output)
    report_latency_statistics(df, baseline_strategy="queue-depth")
    report_decision_overhead(df, heuristic_baseline="queue-depth")

    # Grid Plot
    plt.figure(figsize=(16, 12))
    fig, axes = plt.subplots(2, 2, figsize=(16, 12))
    hue_col = "archetype"
    sns.barplot(data=df, x="strategy", y="is_success", hue=hue_col, ax=axes[0, 0])
    sns.boxplot(
        data=df[df["is_success"] == 1],
        x="strategy",
        y="q_depth",
        hue=hue_col,
        ax=axes[0, 1],
    )
    sns.barplot(
        data=df[df["cost"] > 0], x="strategy", y="cost", hue=hue_col, ax=axes[1, 0]
    )
    sns.violinplot(data=df, x="strategy", y="latency", hue=hue_col, ax=axes[1, 1])
    plt.tight_layout()
    plt.savefig(os.path.join(args.output, "grid.svg"))
    plt.close()

    # Final logic plots
    plt.figure(figsize=(10, 6))
    sns.boxplot(
        data=df[df["is_success"] == 1], x="strategy", y="regret", hue="archetype"
    )
    plt.savefig(os.path.join(args.output, "regret.svg"))
    plt.close()

    plt.figure(figsize=(12, 6))
    sns.countplot(data=df[df["is_success"] == 1], x="archetype", hue="strategy")
    plt.savefig(os.path.join(args.output, "archetype.svg"))
    plt.close()

    df.to_csv(args.output_csv, index=False)
    run_stats(df, args.baseline)
    print(f"\nAnalysis complete. Results in {args.output}")
    fr = df[df.strategy == "first-ready"]
    print("SUCCESS RATES of first ready")
    print(fr.status.value_counts())
    print("Latency means and std across strategies")
    df.groupby(["strategy"]).latency.std()
    df.groupby(["strategy"]).latency.std()
    print('first ready and random did not select hpc')
    print(df[df.strategy=='first-ready'].archetype.unique())
    print(df[df.strategy=='random'].archetype.unique())


if __name__ == "__main__":
    main()
