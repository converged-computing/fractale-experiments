#!/usr/bin/env python3
"""
Usage:
    python plot_issues.py data.json [--experiment 1k] [--out figure.png]
"""

import argparse
import json
import re
import sys
from collections import defaultdict

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

FLAG_RE = re.compile(
    r"""
    (?:
        '([^']+)'           |
        `([^`]+)`           |
        (--[\w][\w-]*)      |
        (?<!\w)(-[A-Za-z])  |
        (%[a-zA-Z])
    )
    """,
    re.VERBOSE,
)
INNER_FLAG_RE = re.compile(r"(--[\w][\w-]*|-[A-Za-z]|%[a-zA-Z])")

# Flags that are not scheduler directives (Python/app-level false positives)
FALSE_POSITIVES = {"-m", "--nproc_per_node"}

ISSUE_TYPES = ["MISSING", "NO_ANALOGOUS", "UNKNOWN_TO_ME"]


def extract_flags(message: str) -> list:
    flags = []
    for m in FLAG_RE.finditer(message):
        quoted = m.group(1) or m.group(2)
        if quoted:
            for inner in INNER_FLAG_RE.findall(quoted):
                flags.append(inner.split("=")[0])
        else:
            flag = m.group(3) or m.group(4) or m.group(5)
            if flag:
                flags.append(flag.split("=")[0])
    seen, out = set(), []
    for f in flags:
        if f not in seen and f not in FALSE_POSITIVES:
            seen.add(f)
            out.append(f)
    return out


def collect_flag_counts(data: dict, experiment: str | None = None) -> dict:
    """Return {flag: count} summed across all issue types for the given experiment."""
    counts: dict[str, int] = defaultdict(int)
    for exp, jobs in data.items():
        if experiment and exp != experiment:
            continue
        for job in jobs:
            for issue in job.get("issues", []):
                if len(issue) < 2:
                    continue
                itype, msg = issue[0].strip(), issue[1].strip()
                if itype not in ISSUE_TYPES:
                    continue
                for f in extract_flags(msg):
                    counts[f] += 1
    return dict(counts)


# ── category definitions ─────────────────────────────────────────────────────
# Each category is a (label, color, set-of-flags) tuple.
# Flags not matched by any category are silently dropped from the chart.

CATEGORIES = [
    (
        "Output/Error & templating",
        "#534AB7",
        {
            "--output",
            "--error",
            "-o",
            "-e",
            "-j",
            "--open-mode",
            "--stdout",
            "--stderr",
            "%j",
            "%J",
            "%A",
            "%a",
            "%x",
            "%N",
            "%u",
            "%I",
            "%n",
            "%c",
            "%t",
        },
    ),
    (
        "Memory allocation",
        "#534AB7",
        {"--mem", "--mem-per-cpu", "--tmp"},
    ),
    (
        "Process topology & binding",
        "#534AB7",
        {
            "--ntasks-per-socket",
            "--ntasks-per-core",
            "--tasks-per-core",
            "--tasks-per-node",
            "--hint",
            "--constraint",
            "-C",
            "--exclude",
            "--nodelist",
            "--bind-to",
            "--cpu-bind",
            "--cpu_bind",
            "--map-by",
            "--distribution",
            "--contiguous",
            "--accel-bind",
            "--threads-per-core",
        },
    ),
    (
        "GPU specification",
        "#D85A30",
        {
            "--gres",
            "--gpus-per-task",
            "--gpus-per-node",
            "--gpus",
            "--cpus-per-gpu",
            "--gres-flags",
        },
    ),
    (
        "MPI & launcher",
        "#888780",
        {"--mpi", "--cc", "--smpiargs", "--launcher", "--ppn", "--report-bindings"},
    ),
    (
        "Job arrays",
        "#D85A30",
        {"--array"},
    ),
    (
        "Environment management",
        "#534AB7",
        {
            "--export",
            "--get-user-env",
            "-V",
            "--env",
            "--env-remove",
            "--envall",
            "--module",
            "--setopt",
        },
    ),
    (
        "Dependency & scheduling",
        "#534AB7",
        {
            "--dependency",
            "--reservation",
            "--requeue",
            "--no-requeue",
            "--priority",
            "--urgency",
            "--wait",
            "--latency_priority",
            "--launch_distribution",
        },
    ),
]


def aggregate_categories(flag_counts: dict) -> list[tuple[str, str, int]]:
    """Return [(label, color, total)] sorted descending by total."""
    rows = []
    for label, color, flags in CATEGORIES:
        total = sum(flag_counts.get(f, 0) for f in flags)
        rows.append((label, color, total))
    rows.sort(key=lambda x: x[2])  # ascending so top bar is largest
    return rows


# ── plotting ─────────────────────────────────────────────────────────────────


def plot(rows: list[tuple[str, str, int]], experiment: str, out_path: str):
    labels = [r[0] for r in rows]
    colors = [r[1] for r in rows]
    values = [r[2] for r in rows]

    fig, ax = plt.subplots(figsize=(9, 5))
    bars = ax.barh(labels, values, color=colors, height=0.55, zorder=2)

    # value labels on bars
    for bar, val in zip(bars, values):
        ax.text(
            bar.get_width() + max(values) * 0.01,
            bar.get_y() + bar.get_height() / 2,
            str(val),
            va="center",
            ha="left",
            fontsize=9,
            color="#444441",
        )

    ax.set_xlabel("Flag occurrences", fontsize=10, color="#5F5E5A")
    ax.set_title(
        f"Flux Translation Issues by Category",
        fontsize=11,
        pad=14,
        color="#2C2C2A",
    )
    ax.set_xlim(0, max(values) * 1.15)
    ax.tick_params(axis="y", labelsize=9, colors="#444441")
    ax.tick_params(axis="x", labelsize=8, colors="#888780")
    ax.spines[["top", "right", "left"]].set_visible(False)
    ax.spines["bottom"].set_color("#D3D1C7")
    ax.xaxis.grid(True, color="#D3D1C7", linewidth=0.5, zorder=0)
    ax.set_axisbelow(True)

    # legend for colors
    legend_handles = [
        mpatches.Patch(color="#534AB7", label="NO_ANALOGOUS dominant"),
        mpatches.Patch(color="#D85A30", label="MISSING dominant"),
        mpatches.Patch(color="#888780", label="Mixed"),
    ]
    ax.legend(
        handles=legend_handles,
        fontsize=8,
        frameon=False,
        loc="lower right",
        bbox_to_anchor=(1, 0),
    )

    # footnote
    # fig.text(
    #    0.13, -0.02,
    #    "* Output/Error & templating: routing flags and format specifiers overlap "
    #    "within single issue messages",
    #    fontsize=7, color="#888780",
    # )

    plt.tight_layout()
    plt.savefig(out_path, dpi=150, bbox_inches="tight")
    print(f"Saved → {out_path}")


# ── entry point ───────────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(description="Plot SLURM→Flux issue categories.")
    parser.add_argument("input", help="Path to data.json")
    parser.add_argument(
        "--experiment",
        default=None,
        help="Experiment key to filter (e.g. '1k'). "
        "Omit to aggregate all experiments.",
    )
    parser.add_argument(
        "--out",
        default="issues_by_category.png",
        help="Output image path (default: issues_by_category.png)",
    )
    args = parser.parse_args()

    with open(args.input) as f:
        data = json.load(f)

    exp_label = args.experiment or "all"
    flag_counts = collect_flag_counts(data, args.experiment)
    rows = aggregate_categories(flag_counts)

    plot(rows, exp_label, args.out)


if __name__ == "__main__":
    main()
