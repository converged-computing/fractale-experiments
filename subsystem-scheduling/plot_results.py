#!/usr/bin/env python3
"""Parse the experiment runs and draw the figures.

Two steps, one file, because they have to agree about what the data means and
keeping them apart invited them to drift.

    analyze.py parse   --runs runs/0 runs/1 ... --out dataset.json
    analyze.py figures --data dataset.json --out figures
    analyze.py all     --runs runs/* --out-data dataset.json --out figures

`parse` reads the broker logs and per-job records under each run directory and
emits one JSON file: a record per run with its cluster, status, launch attempts,
figures of merit and agent state, plus the paired comparisons between conditions.

`figures` reads that file and writes each figure twice, as SVG for the web and
PDF for LaTeX, from one source so the two cannot differ.
"""

from __future__ import annotations

import argparse
import collections
import glob
import json
import os
import re
import statistics
import sys

# The backend must be chosen before pyplot is imported, so this block is ordered
# by hand rather than alphabetically.
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import pandas as pd  # noqa: E402
import seaborn as sns  # noqa: E402
from matplotlib.ticker import FuncFormatter  # noqa: E402

# Broker logs carry terminal colour codes; strip them before matching anything.
ANSI = re.compile(r"\x1b\[[0-9;]*m")

BASE = "#d95f02"

SUB = "#0173b2"

GREY = "#666666"

# one colour per condition, used identically in every figure
PAL = {"base": BASE, "subsystem": SUB}

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": ["DejaVu Sans", "Helvetica", "Arial"],
    "font.size": 9,
    "axes.labelsize": 9,
    "axes.titlesize": 9.5,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8,
    "legend.fontsize": 8,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.color": "#dddddd",
    "grid.linewidth": 0.6,
    "figure.dpi": 150,
    "savefig.bbox": "tight",
    "savefig.pad_inches": 0.02,
})

SIZE_KEYS = {"hpl_n", "points", "cg_iterations", "atoms"}

PRIMARY = {
    "metric-kripke-cpu": ["grind_time"],
    "metric-lammps-cpu": ["atom_steps_s", "wall_time"],
    "metric-linpack-cpu": ["gflops"],
    "metric-minife": ["setup_time"],
    "metric-mixbench": ["peak_gflops", "peak_gb_s"],
    "metric-osu-cpu": ["latency_8b"],
    "metric-stream": ["triad_mb_s"],
    "osu-benchmark": ["latency_8b"],
}

APP_LABEL = {
    "metric-kripke-cpu": "kripke",
    "metric-lammps-cpu": "lammps",
    "metric-linpack-cpu": "linpack",
    "metric-minife": "miniFE",
    "metric-mixbench": "mixbench",
    "metric-osu-cpu": "osu (amd64)",
    "osu-benchmark": "osu (arm64)",
    "metric-quicksilver-cpu": "quicksilver (amd64)",
    "metrics-quicksilver-cpu": "quicksilver (arm64)",
    "metric-stream": "stream",
    "metric-amg2023": "AMG2023",
}

SHORT = {
    "sched-gke-cpu": "gke-cpu", "sched-gke-mid": "gke-mid",
    "sched-gke-bigmem": "gke-bigmem", "sched-gke-arm": "gke-arm",
    "sched-eks-arm-small": "eks-arm", "sched-eks-cpu-efa-bigmem": "eks-efa",
}

short = lambda c: SHORT.get(c, str(c).replace("sched-", ""))

app_short = lambda a: APP_LABEL.get(a, a.replace("metric-", "").replace("metrics-", ""))

BOXES = [
    ("metric-lammps-cpu", "atom_steps_s", "LAMMPS", "katom-step/s", True,
     1 / 1000, "cluster"),
    ("metric-linpack-cpu", "gflops", "LINPACK", "Gflops", True, 1, "all"),
    ("metric-mixbench", "peak_gflops", "mixbench", "GFLOP/s", True, 1, "all"),
    # Pooled rather than split by cluster. AMG is the quietest measurement in the
    # study -- repeat runs on one cluster agree to about 1% -- so the two
    # conditions separate cleanly here, where splitting into four small per-cluster
    # groups hides it.
    ("metric-amg2023", "figure_of_merit", "AMG2023", "$10^7$ nnz/s", True,
     1 / 1e7, "all"),
]



def clean(text: str) -> str:
    return ANSI.sub("", text or "")


# ---------------------------------------------------------------------------
# figures of merit
#
# Each returns a dict of metric -> {value, unit, higher_is_better}. Higher or
# lower being better is recorded rather than assumed, because the report compares
# two placements and the direction decides which one won.
# ---------------------------------------------------------------------------


def fom_stream(out: str) -> dict:
    got = {}
    for kernel, rate in re.findall(
        r"^(Copy|Scale|Add|Triad):\s+([\d.]+)", out, re.M
    ):
        got[f"{kernel.lower()}_mb_s"] = {
            "value": float(rate), "unit": "MB/s", "higher_is_better": True,
        }
    return got


def fom_kripke(out: str) -> dict:
    got = {}
    m = re.search(r"Throughput:\s+([\d.e+-]+)", out)
    if m:
        got["throughput"] = {
            "value": float(m.group(1)),
            "unit": "unknowns/(s/iter)", "higher_is_better": True,
        }
    m = re.search(r"Grind time\s*:\s+([\d.e+-]+)", out)
    if m:
        got["grind_time"] = {
            "value": float(m.group(1)),
            "unit": "(s/iter)/unknown", "higher_is_better": False,
        }
    m = re.search(r"Sweep efficiency\s*:\s+([\d.]+)", out)
    if m:
        got["sweep_efficiency"] = {
            "value": float(m.group(1)), "unit": "%", "higher_is_better": True,
        }
    return got


def fom_lammps(out: str) -> dict:
    """LAMMPS reports its own rate; the atom-step rate is the figure of merit.

    Loop time and timesteps/s both depend on how many atoms the run had, so they
    only compare across identical inputs. atom-step/s normalises by the work done
    and is what LAMMPS itself puts on the Performance line. Total wall time is the
    other number worth having, since it includes setup rather than just the loop.

        Performance: 0.181 ns/day, 132.647 hours/ns, 20.941 timesteps/s, 50.929 katom-step/s
        Total wall time: 0:00:04
    """
    got = {}

    # Matom-step/s, katom-step/s or atom-step/s, normalised to atom-step/s
    m = re.search(r"([\d.]+)\s*([MkK]?)atom-step/s", out)
    if m:
        scale = {"M": 1e6, "k": 1e3, "K": 1e3, "": 1.0}[m.group(2)]
        got["atom_steps_s"] = {
            "value": float(m.group(1)) * scale,
            "unit": "atom-step/s", "higher_is_better": True,
        }

    m = re.search(r"Total wall time:\s*(\d+):(\d+):(\d+)", out)
    if m:
        h, mi, sec = (int(x) for x in m.groups())
        got["wall_time"] = {
            "value": h * 3600 + mi * 60 + sec,
            "unit": "s", "higher_is_better": False,
        }

    # kept for context, not as the comparison: both scale with the atom count
    m = re.search(r"Loop time of ([\d.]+)", out)
    if m:
        got["loop_time"] = {
            "value": float(m.group(1)), "unit": "s", "higher_is_better": False}
    m = re.search(r"with (\d+) atoms", out)
    if m:
        got["atoms"] = {"value": float(m.group(1)), "unit": "count",
                        "higher_is_better": None}
    return got


def fom_hpl(out: str) -> dict:
    """HPL's rate is the figure of merit; the solve time is not comparable.

        T/V                N    NB     P     Q               Time             Gflops
        WR11C2R4       24650   192     2     4              17.04          5.859e+02

    Time scales with N, so two arms that solved different sizes produce a time
    ratio that says nothing. N is kept so such a pair is visible.
    """
    rows = re.findall(
        r"^W[R\w]+\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([\d.]+)\s+([\d.e+-]+)",
        out, re.M,
    )
    if not rows:
        return {}
    best = max(rows, key=lambda r: float(r[5]))
    return {
        "gflops": {"value": float(best[5]), "unit": "GFLOP/s",
                   "higher_is_better": True},
        "hpl_n": {"value": float(best[0]), "unit": "N", "higher_is_better": None},
    }


def fom_mixbench(out: str) -> dict:
    # compute iters, flops/byte, ex.time, GFLOPS, GB/sec  (x3 precisions)
    rows = re.findall(
        r"^\s*(\d+),\s*([\d.]+),\s*([\d.]+),\s*([\d.]+),\s*([\d.]+),", out, re.M
    )
    if not rows:
        return {}
    gflops = [float(r[3]) for r in rows]
    gbs = [float(r[4]) for r in rows]
    return {
        "peak_gflops": {"value": max(gflops), "unit": "GFLOP/s",
                        "higher_is_better": True},
        "peak_gb_s": {"value": max(gbs), "unit": "GB/s", "higher_is_better": True},
        "points": {"value": float(len(rows)), "unit": "count",
                   "higher_is_better": None},
    }


def fom_quicksilver(out: str) -> dict:
    m = re.search(r"Figure Of Merit\s+([\d.e+-]+)", out)
    if not m:
        return {}
    return {"figure_of_merit": {
        "value": float(m.group(1)), "unit": "segments/s",
        "higher_is_better": True}}


def fom_minife(out: str) -> dict:
    got = {}
    m = re.findall(r"total time:\s*([\d.e+-]+)", out)
    if m:
        got["setup_time"] = {"value": float(m[-1]), "unit": "s",
                             "higher_is_better": False}
    m = re.search(r"Final Resid Norm:\s*([\d.e+-]+)", out)
    if m:
        got["final_residual"] = {"value": float(m.group(1)), "unit": "norm",
                                 "higher_is_better": None}
    it = re.findall(r"Iteration = (\d+)", out)
    if it:
        got["cg_iterations"] = {"value": float(it[-1]), "unit": "count",
                                "higher_is_better": False}
    return got


def fom_amg(out: str) -> dict:
    """AMG2023 reports its own figure of merit, so we take it rather than time it.

    FOM is nnz_AP / (setup + 3 * solve), which normalises by the work done and is
    therefore comparable across problem sizes. The two phases are reported
    separately as well: setup dominates here and is the part that varies with the
    machine, while the solve is short enough at these sizes to be mostly noise.

    Note the grid: -n is PER PROCESS, not global, so 16 ranks of 24^3 is a
    384x24x24 problem of 221k unknowns rather than 13.8k.
    """
    got = {}
    m = re.search(r"Figure of Merit \(FOM\)[^\n]*?([\d.]+e[+-]\d+)", out)
    if m:
        got["figure_of_merit"] = {"value": float(m.group(1)), "unit": "nnz/s",
                                  "higher_is_better": True}
    m = re.search(r"PCG Setup:\s*\n?\s*wall clock time = ([\d.e+-]+)", out)
    if m:
        got["setup_time"] = {"value": float(m.group(1)), "unit": "s",
                             "higher_is_better": False}
    m = re.search(r"PCG Solve:\s*\n?\s*wall clock time = ([\d.e+-]+)", out)
    if m:
        got["solve_time"] = {"value": float(m.group(1)), "unit": "s",
                             "higher_is_better": False}
    m = re.search(r"Iterations = (\d+)", out)
    if m:
        # the problem, not the machine: it must match across a pair or the two
        # runs did not solve the same system
        got["cg_iterations"] = {"value": float(m.group(1)), "unit": "count",
                                "higher_is_better": None}
    m = re.search(r"\(Nx, Ny, Nz\) = \((\d+), (\d+), (\d+)\)", out)
    if m:
        got["unknowns"] = {"value": float(int(m.group(1)) * int(m.group(2))
                                         * int(m.group(3))),
                           "unit": "count", "higher_is_better": None}
    return got


def fom_osu(out: str) -> dict:
    """OSU prints a curve; the smallest size is the latency floor."""
    rows = re.findall(r"^(\d+)\s+([\d.]+)", out, re.M)
    if not rows:
        return {}
    curve = [(int(s), float(v)) for s, v in rows]
    curve.sort()
    latency = "Latency" in out
    got = {
        # The direction is a property of the measurement, not of the shape. A
        # latency sweep is lower-is-better at every point and a bandwidth sweep is
        # higher-is-better; leaving it None made the curve uncomparable and cost
        # osu-benchmark its only available verdict.
        "curve": {"value": curve, "unit": "us" if latency else "MB/s",
                  "higher_is_better": not latency},
    }
    if latency:
        got["latency_8b"] = {"value": curve[0][1], "unit": "us",
                             "higher_is_better": False}
        got["latency_max_size"] = {"value": curve[-1][1], "unit": "us",
                                   "higher_is_better": False}
    else:
        got["bandwidth_peak"] = {"value": max(v for _, v in curve),
                                 "unit": "MB/s", "higher_is_better": True}
    return got


# Matched on the app directory name, longest prefix first so kripke-gpu does not
# fall through to a kripke-cpu rule.
EXTRACTORS = [
    ("metric-stream", fom_stream),
    ("metric-kripke", fom_kripke),
    ("metric-lammps", fom_lammps),
    ("metric-linpack", fom_hpl),
    ("metric-mixbench", fom_mixbench),
    ("quicksilver", fom_quicksilver),
    ("metric-minife", fom_minife),
    ("metric-amg", fom_amg),
    ("osu", fom_osu),
]


def figures_of_merit(app: str, out: str) -> dict:
    for prefix, fn in sorted(EXTRACTORS, key=lambda x: -len(x[0])):
        if prefix in app:
            try:
                return fn(out)
            except Exception:  # noqa: BLE001 - a bad parse must not lose the run
                return {}
    return {}


# ---------------------------------------------------------------------------
# transcript
# ---------------------------------------------------------------------------

FIELD = re.compile(r"(\w+)=('[^']*'|\S+)")


def fields(line: str) -> dict:
    out = {}
    for k, v in FIELD.findall(line):
        out[k] = v.strip("'")
    return out


def application_output(text: str) -> tuple[str, str]:
    """stdout and stderr of the attempt that succeeded, else of the last one."""
    outs = re.findall(
        r"attempt (\d+) stdout ===\n(.*?)FLUXSEC === end attempt \1 stdout",
        text, re.S)
    errs = re.findall(
        r"attempt (\d+) stderr ===\n(.*?)FLUXSEC === end attempt \1 stderr",
        text, re.S)
    ok = None
    for line in text.splitlines():
        if line.startswith("FLUXSEC attempt ") and fields(line).get("status") == "ok":
            ok = fields(line).get("n")
    pick = lambda pairs: next(  # noqa: E731
        (b for n, b in pairs if n == ok), pairs[-1][1] if pairs else "")
    return pick(outs), pick(errs)


EMPTY = {
    "attempts": [], "runtime_s": None, "successful_attempt": None,
    "wall_s": None, "reason": None, "mode": None,
    "attempt_timeout_s": None, "attempts_max": None, "log_chars": 0,
}


def parse_log(path: str) -> dict:
    """The transcript, or a record saying why there is not one.

    Every branch returns the same shape: a missing log is a fact about the capture
    and not about the run, and the caller should not have to guess which keys are
    present.
    """
    try:
        text = clean(open(path, errors="replace").read())
    except OSError:
        return {**EMPTY, "status": "no-log"}

    stripped = text.strip()
    if not stripped or stripped.startswith("(no "):
        # the placeholder the harness leaves when the pods were already gone
        return {**EMPTY, "status": "no-log", "log_chars": len(text)}
    if "FLUXSEC" not in text:
        return {**EMPTY, "status": "never-started", "log_chars": len(text)}

    attempts = []
    for line in text.splitlines():
        if not line.startswith("FLUXSEC attempt status="):
            continue
        f = fields(line)
        attempts.append({
            "n": int(f.get("n", len(attempts) + 1)),
            "status": f.get("status"),
            "rc": f.get("rc"),
            "exception": None if f.get("exception") in ("-", None) else f.get("exception"),
            "runtime_s": None if f.get("runtime_s") in ("-", None) else float(f["runtime_s"]),
            "nodes": f.get("nodes"),
            "tasks": f.get("tasks"),
            "gpus_per_task": None if f.get("gpus_per_task") == "-" else f.get("gpus_per_task"),
            "environment": None if f.get("environment") == "-" else f.get("environment"),
            "cpu_affinity": None if f.get("cpu_affinity") == "-" else f.get("cpu_affinity"),
            "why": f.get("why"),
            "args_changed": None if f.get("args_changed") in ("-", None) else f.get("args_changed"),
        })

    mode = {}
    all_modes = re.findall(r"^FLUXSEC mode (.*)$", text, re.M)
    if all_modes:
        mode = fields(all_modes[-1])
    api_retries = len(re.findall(r"^FLUXSEC api_retry ", text, re.M))
    agent_lost = bool(re.search(r"agent unavailable|ServiceUnavailable", text))

    result = {}
    m = re.search(r"^FLUXSEC result (.*)$", text, re.M)
    if m:
        result = fields(m.group(1))

    ran = next((a for a in attempts if a["status"] == "ok"), None)
    status = ("ok" if result.get("status") == "ok" and ran
              else "failed" if result else "incomplete")

    # the submit command of each attempt, which is what the agent chose
    cmds = dict(re.findall(r"=== attempt (\d+): (.*?) ===", text))
    for a in attempts:
        a["command"] = cmds.get(str(a["n"]))

    return {
        "status": status,
        "attempts": attempts,
        "runtime_s": ran["runtime_s"] if ran else None,
        "successful_attempt": ran["n"] if ran else None,
        "wall_s": float(result["wall_s"]) if result.get("wall_s") else None,
        "reason": result.get("reason") if result.get("reason") != "-" else None,
        "mode": mode.get("mode"),
        "api_retries": api_retries,
        "agent_lost": agent_lost,
        "attempt_timeout_s": mode.get("attempt_timeout_s"),
        "attempts_max": mode.get("attempts_max"),
        "log_chars": len(text),
    }


def parse_replicate(runs_dir: str, replicate: int) -> list[dict]:
    records = []
    for spec in sorted(glob.glob(os.path.join(runs_dir, "*", "*.json"))):
        if "manifest" in os.path.basename(spec):
            continue
        app = os.path.basename(os.path.dirname(spec))
        cond = os.path.basename(spec)[:-5]
        try:
            rec = json.load(open(spec))
        except (OSError, json.JSONDecodeError):
            rec = {}
        log = spec.replace(".json", ".broker.log")
        parsed = parse_log(log)
        out, err = ("", "")
        if parsed["status"] not in ("no-log", "never-started"):
            out, err = application_output(clean(open(log, errors="replace").read()))
        records.append({
            "replicate": replicate,
            "app": app,
            "condition": cond,
            "cluster": rec.get("ClusterID"),
            "state": rec.get("State"),
            "note": rec.get("Note"),
            **parsed,
            "fom": figures_of_merit(app, out + "\n" + err),
            "stdout_tail": "\n".join(out.strip().splitlines()[-60:]),
            "stderr_tail": "\n".join(err.strip().splitlines()[-40:]),
        })
    return records


def summarise(records: list[dict]) -> dict:
    apps = sorted({r["app"] for r in records})
    reps = sorted({r["replicate"] for r in records})
    pairs = []
    for app in apps:
        for rep in reps:
            b = next((r for r in records
                      if r["app"] == app and r["condition"] == "base"
                      and r["replicate"] == rep), None)
            s = next((r for r in records
                      if r["app"] == app and r["condition"] == "subsystem"
                      and r["replicate"] == rep), None)
            if not (b and s):
                continue
            row = {
                "app": app, "replicate": rep,
                "base_cluster": b["cluster"], "subsystem_cluster": s["cluster"],
                "differs": bool(b["cluster"] and s["cluster"]
                                and b["cluster"] != s["cluster"]),
                "base_status": b["status"], "subsystem_status": s["status"],
                "base_runtime_s": b["runtime_s"], "subsystem_runtime_s": s["runtime_s"],
                "base_attempts": len(b["attempts"]),
                "subsystem_attempts": len(s["attempts"]),
            }
            if b["runtime_s"] and s["runtime_s"]:
                row["runtime_delta_s"] = round(s["runtime_s"] - b["runtime_s"], 4)
                row["runtime_ratio"] = round(s["runtime_s"] / b["runtime_s"], 4)
            # every metric both sides reported
            row["fom"] = {}
            for k, bv in (b["fom"] or {}).items():
                sv = (s["fom"] or {}).get(k)
                if not sv or isinstance(bv["value"], list):
                    continue
                better = bv["higher_is_better"]
                d = {"unit": bv["unit"], "base": bv["value"], "subsystem": sv["value"],
                     "higher_is_better": better}
                if bv["value"]:
                    d["ratio"] = round(sv["value"] / bv["value"], 4)
                if better is not None:
                    d["winner"] = (
                        "subsystem" if (sv["value"] > bv["value"]) == bool(better)
                        else "base" if sv["value"] != bv["value"] else "tie")
                row["fom"][k] = d
            pairs.append(row)

    both = [p for p in pairs if p["base_cluster"] and p["subsystem_cluster"]]
    deltas = [p["runtime_delta_s"] for p in pairs if "runtime_delta_s" in p]
    counts = {}
    for r in records:
        counts.setdefault(r["condition"], {}).setdefault(r["status"], 0)
        counts[r["condition"]][r["status"]] += 1
    return {
        "replicates": reps,
        "apps": len(apps),
        "records": len(records),
        "pairs": len(pairs),
        "with_both_placements": len(both),
        "placement_differs": sum(1 for p in both if p["differs"]),
        "outcomes": counts,
        "paired_runtimes": len(deltas),
        "median_runtime_delta_s": round(statistics.median(deltas), 4) if deltas else None,
        "comparisons": pairs,
    }


def save(fig, out, name):
    os.makedirs(out, exist_ok=True)
    for ext in ("svg", "pdf"):
        fig.savefig(os.path.join(out, f"{name}.{ext}"))
    plt.close(fig)
    print(f"  {name}.svg  {name}.pdf")


def won(rec):
    return next((a for a in rec["attempts"] if a["status"] == "ok"), {}) or {}


# ---------------------------------------------------------------------------


def fig_execution(d, out):
    """Did the job run at all, per application.

    The paper's central result. Base's failures are almost entirely architecture
    mismatch, so the bar is split to show that rather than leaving it as a total.
    """
    recs = d["records"]
    apps = sorted({r["app"] for r in recs})
    ARM_CLUSTERS = {"sched-gke-arm", "sched-eks-arm-small"}
    ARM_APPS = {"metrics-quicksilver-cpu", "osu-benchmark"}

    ran = {a: {"base": 0, "subsystem": 0} for a in apps}
    mism = {a: {"base": 0, "subsystem": 0} for a in apps}
    for r in recs:
        if r["status"] == "ok":
            ran[r["app"]][r["condition"]] += 1
        elif r["cluster"]:
            on_arm = r["cluster"] in ARM_CLUSTERS
            if on_arm != (r["app"] in ARM_APPS):
                mism[r["app"]][r["condition"]] += 1

    # Order by how much the two conditions differ, so the effect is the first
    # thing read rather than something to be found alphabetically.
    apps.sort(key=lambda a: ran[a]["subsystem"] - ran[a]["base"])

    fig, ax = plt.subplots(figsize=(6.6, 3.2))
    h = 0.38
    for i, a in enumerate(apps):
        for arm, colour, off in (("base", BASE, h / 2), ("subsystem", SUB, -h / 2)):
            n = ran[a][arm]
            ax.barh(i + off, n, height=h, color=colour,
                    label=arm if i == 0 else None)
            m = mism[a][arm]
            if m:
                # The bar is extended to show what the run would have been had it
                # executed, hatched to mark that it did not: the job was dispatched
                # to a node whose architecture could not run the image.
                ax.barh(i + off, m, height=h, left=n, facecolor="none",
                        hatch="////", edgecolor=colour, linewidth=0.8,
                        label="dispatched, could not execute" if i == 0 and arm == "base"
                        else None)
    ax.set_yticks(range(len(apps)))
    ax.set_yticklabels([app_short(a) for a in apps])
    ax.invert_yaxis()
    ax.set_xlabel("Number of Runs")
    ax.set_xlim(0, 10)
    ax.set_xticks(range(0, 11, 2))
    ax.grid(axis="y", visible=False)
    # Outside the axes: with bars reaching 10 there is no interior space that does
    # not sit on top of data.
    ax.legend(loc="lower center", bbox_to_anchor=(0.5, -0.34), ncol=3,
              frameon=False, columnspacing=1.4, handlelength=1.4, fontsize=12)
    save(fig, out, "execution")


def fig_placement(d, out):
    """Where each arm sent its jobs.

    Base is near-uniform because every cluster is feasible and the tie is broken at
    random; that uniformity is the control saying the fleet was reachable. The
    subsystem arm is shaped by what the applications ask for.
    """
    t = collections.Counter()
    for r in d["records"]:
        if r["cluster"]:
            t[(r["condition"], r["cluster"])] += 1
    clusters = sorted({c for _, c in t}, key=lambda c: -t[("base", c)])

    fig, ax = plt.subplots(figsize=(6.0, 2.7))
    x = range(len(clusters))
    w = 0.38
    for arm, colour, off in (("base", BASE, -w / 2), ("subsystem", SUB, w / 2)):
        vals = [t[(arm, c)] for c in clusters]
        ax.bar([i + off for i in x], vals, width=w, color=colour, label=arm)
    ax.axhline(100 / len(clusters), color=GREY, lw=0.9, ls=(0, (4, 3)))
    ax.text(len(clusters) - 0.4, 100 / len(clusters) + 0.6,
            "uniform", ha="right", fontsize=7, color=GREY)
    ax.set_xticks(list(x))
    ax.set_xticklabels([short(c) for c in clusters], rotation=20, ha="right")
    ax.set_ylabel("Jobs Placed")
    ax.grid(axis="x", visible=False)
    ax.legend(frameon=False, loc="upper right")
    save(fig, out, "placement")


def _frame(records, app, key, scale=1):
    """One row per run: cluster, condition, value."""
    rows = []
    for r in records:
        if r["app"] != app:
            continue
        f = (r.get("fom") or {}).get(key)
        if not f or isinstance(f.get("value"), list) or not r["cluster"]:
            continue
        rows.append({"cluster": short(r["cluster"]), "condition": r["condition"],
                     "value": f["value"] * scale})
    return pd.DataFrame(rows)


def panel_osu(ax, d, app="osu-benchmark"):
    """Latency at every message size: median, the range, and every run.

    A single point cannot separate a real offset from one noisy measurement, while
    a difference holding across the whole sweep can only be the machine. Here the
    subsystem condition is lower at all ten sizes, which is a sign test at p=0.002.

    Individual runs are drawn because several sizes rest on three base
    observations, and a median line alone would not show that.
    """
    per = collections.defaultdict(list)
    unit = "us"
    for r in d["records"]:
        if r["app"] != app:
            continue
        c = (r.get("fom") or {}).get("curve") or {}
        if not c.get("value"):
            continue
        unit = c.get("unit") or unit
        for x, v in c["value"]:
            per[(r["condition"], x)].append(v)
    xs = sorted({x for _, x in per})
    if not xs:
        ax.axis("off")
        return

    # the two conditions are nudged apart so their ranges do not overlie
    for arm, colour, off in (("base", BASE, 0.96), ("subsystem", SUB, 1.04)):
        med, lo, hi, pts = [], [], [], []
        for x in xs:
            v = per[(arm, x)]
            if not v:
                med.append(None), lo.append(None), hi.append(None)
                continue
            med.append(statistics.median(v))
            lo.append(min(v))
            hi.append(max(v))
            pts += [(x * off, y) for y in v]
        ax.plot([x * off for x in xs], med, "-o", color=colour, ms=4, lw=1.6,
                label=arm, zorder=3)
        ax.vlines([x * off for x in xs], lo, hi, color=colour, lw=1.1, alpha=0.4,
                  zorder=1)
        if pts:
            ax.scatter([a for a, _ in pts], [b for _, b in pts], s=5.5,
                       color=colour, alpha=0.35, zorder=2)
    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xticks(xs)
    ax.set_xticklabels([str(x) for x in xs], rotation=45, ha="right", fontsize=6.5)
    ax.set_xlabel("Message Size (bytes)", fontsize=8)
    ax.set_ylabel(f"Latency ({unit})", fontsize=8)
    ax.set_title("OSU allreduce (arm64)", fontsize=9)
    ax.legend(frameon=False, fontsize=7.5, loc="upper left")
    ax.tick_params(axis="y", labelsize=7)
    ax.grid(axis="x", visible=False)


def panel_box(ax, records, app, key, title, ylab, hib, scale=1, mode="cluster"):
    """Boxes by cluster, pooled, or both.

    mode="cluster"  per cluster only, which shows that performance is a property
                    of the machine rather than of the condition
    mode="all"      pooled only, which is what a user experiences
    mode="both"     per cluster with the pooled view after a rule
    """
    df = _frame(records, app, key, scale)
    if df.empty:
        ax.axis("off")
        return
    order = list(df.groupby("cluster")["value"].median()
                 .sort_values(ascending=not hib).index)
    if mode == "all":
        # Pooled: one group, so put the condition on the x axis. Two unlabelled
        # boxes under a heading of "All" tell a reader nothing.
        df = df.assign(cluster=df["condition"])
        order = [c for c in ("base", "subsystem") if c in set(df["cluster"])]
    elif mode == "both":
        df = pd.concat([df, df.assign(cluster="All")], ignore_index=True)
        order = order + ["All"]
    sns.boxplot(data=df, x="cluster", y="value", hue="condition", palette=PAL,
                order=order, ax=ax, showfliers=False, linewidth=0.8, width=0.72,
                boxprops={"alpha": 0.55})
    sns.stripplot(data=df, x="cluster", y="value", hue="condition", palette=PAL,
                  order=order, ax=ax, dodge=True, size=2.8, alpha=0.85,
                  legend=False)
    if mode == "both":
        ax.axvline(len(order) - 1.5, color=GREY, lw=0.8, ls=(0, (3, 3)))
    ax.set_title(title, fontsize=9)
    ax.set_xlabel("")
    ax.set_ylabel(ylab, fontsize=8)
    if mode == "all":
        ax.tick_params(axis="x", labelrotation=0, labelsize=7.5)
    else:
        ax.tick_params(axis="x", labelrotation=25, labelsize=7)
        for t in ax.get_xticklabels():
            t.set_ha("right")
    ax.tick_params(axis="y", labelsize=7)
    ax.grid(axis="x", visible=False)
    if ax.get_legend():
        ax.get_legend().remove()


# app, metric, title, y label, higher-is-better, scale, grouping
BOXES = [
    ("metric-lammps-cpu", "atom_steps_s", "LAMMPS", "katom-step/s", True,
     1 / 1000, "cluster"),
    ("metric-linpack-cpu", "gflops", "LINPACK", "Gflops", True, 1, "all"),
    ("metric-mixbench", "peak_gflops", "mixbench", "GFLOP/s", True, 1, "all"),
    # Pooled rather than split by cluster. AMG is the quietest measurement in the
    # study -- repeat runs on one cluster agree to about 1% -- so the two
    # conditions separate cleanly here, where splitting into four small per-cluster
    # groups hides it.
    ("metric-amg2023", "figure_of_merit", "AMG2023", "$10^7$ nnz/s", True,
     1 / 1e7, "all"),
]


def fig_exemplars(d, out, views):
    """The four panels in one row, and each again on its own.

    Performance is a property of the cluster, so the split panels carry the
    argument; the pooled ones say what a user was actually given. Which grouping
    suits which application differs, so it is chosen per panel rather than imposed.
    """
    fig = plt.figure(figsize=(11.0, 2.7))
    gs = fig.add_gridspec(1, 1 + len(BOXES), width_ratios=[3, 2, 1.5, 1.5, 1.5],
                          wspace=0.46,
                          left=0.06, right=0.995, top=0.90, bottom=0.22)
    panel_osu(fig.add_subplot(gs[0, 0]), d)
    for k, (app, key, title, ylab, hib, sc, mode) in enumerate(BOXES):
        ax = fig.add_subplot(gs[0, k + 1])
        # A dataset may hold only some applications, as when one is re-run on its
        # own. Draw what is there and leave the rest blank rather than failing.
        if app not in views:
            ax.axis("off")
            continue
        panel_box(ax, views[app]["records"], app, key, title, ylab, hib, sc, mode)
    save(fig, out, "exemplars")

    # the same panels standalone, for slides or a single-column placement
    f, a = plt.subplots(figsize=(3.6, 2.7))
    panel_osu(a, d)
    f.tight_layout()
    save(f, out, "exemplar-osu")
    for app, key, title, ylab, hib, sc, mode in BOXES:
        if app not in views:
            continue
        f, a = plt.subplots(figsize=(2.9 if mode != "all" else 2.2, 2.7))
        panel_box(a, views[app]["records"], app, key, title, ylab, hib, sc, mode)
        if mode != "all":
            # Grouped by cluster, so the condition is carried by colour alone and
            # needs naming. In the combined figure the OSU legend does this for
            # the whole row; standalone, each panel needs its own.
            from matplotlib.patches import Patch
            a.legend(handles=[Patch(facecolor=c, alpha=0.55, edgecolor=c, label=k)
                              for k, c in PAL.items()],
                     frameon=False, fontsize=7.5, loc="upper left")
        f.tight_layout()
        save(f, out, "exemplar-" + title.lower())


# Every application and the metric it is judged on. Distinct from BOXES, which is
# the handful shown in detail; this is the whole corpus at a glance.
ALL_APPS = [
    ("metric-minife", "setup_time", "s", False, 1),
    ("metric-amg2023", "figure_of_merit", "$10^7$ nnz/s", True, 1 / 1e7),
    ("metric-stream", "triad_mb_s", "MB/s", True, 1),
    ("metric-mixbench", "peak_gflops", "GFLOP/s", True, 1),
    ("metric-lammps-cpu", "atom_steps_s", "katom-step/s", True, 1 / 1000),
    ("metric-linpack-cpu", "gflops", "Gflops", True, 1),
    ("metric-kripke-cpu", "grind_time", "s/unknown", False, 1),
    ("metric-osu-cpu", "latency_8b", "us", False, 1),
    ("osu-benchmark", "latency_8b", "us", False, 1),
    ("metric-quicksilver-cpu", "figure_of_merit", "segments/s", True, 1 / 1e6),
    ("metrics-quicksilver-cpu", "figure_of_merit", "segments/s", True, 1 / 1e6),
]


def fig_all_apps(d, out, ncol=4):
    """Every application, both conditions, pooled.

    The exemplar figure shows four applications in detail; this shows all of them
    so a reader can see the whole corpus rather than a selection, including the
    ones where nothing happened. That matters here: most applications show no
    difference, and a figure containing only the ones that moved would misrepresent
    the study.

    Each panel has its own scale, since the metrics share no units, so panels are
    comparable within themselves and not with each other. The count under each box
    is how many runs of that condition completed; several are small enough that the
    box should be read as a sketch of four or five points, not a distribution.
    """
    panels = []
    for app, key, unit, hib, scale in ALL_APPS:
        per = collections.defaultdict(list)
        for r in d["records"]:
            if r["app"] != app or r["status"] != "ok":
                continue
            f = (r.get("fom") or {}).get(key)
            if not f or isinstance(f.get("value"), list) or not f.get("value"):
                continue
            per[r["condition"]].append(f["value"] * scale)
        # A zero figure of merit is not a measurement. The arm64 Quicksilver
        # exits cleanly on every run and reports 0.000e+00 segments per cycle:
        # the process ran, it did no work, and averaging that in would say the
        # two conditions performed identically when neither performed at all.
        for c in list(per):
            per[c] = [v for v in per[c] if v]
        if per.get("base") and per.get("subsystem"):
            panels.append((app, key, unit, hib, per))
        elif any(per.values()) or app == "metrics-quicksilver-cpu":
            print(f"  (skipped {app_short(app)}: no comparable measurement)")
    if not panels:
        print("  (no application data)")
        return

    nrow = (len(panels) + ncol - 1) // ncol
    fig, axes = plt.subplots(nrow, ncol, figsize=(2.35 * ncol, 2.5 * nrow))
    flat = axes.ravel()
    for ax, (app, key, unit, hib, per) in zip(flat, panels):
        rows = [{"condition": c, "value": v} for c in per for v in per[c]]
        df = pd.DataFrame(rows)
        sns.boxplot(data=df, x="condition", y="value", hue="condition", palette=PAL,
                    order=["base", "subsystem"], ax=ax, showfliers=False,
                    linewidth=0.8, width=0.6, boxprops={"alpha": 0.5}, legend=False)
        sns.stripplot(data=df, x="condition", y="value", hue="condition",
                      palette=PAL, order=["base", "subsystem"], ax=ax, size=3.2,
                      alpha=0.9, legend=False)
        mb, ms = statistics.median(per["base"]), statistics.median(per["subsystem"])
        eff = (ms / mb) if hib else (mb / ms)
        arrow = "\u2191" if hib else "\u2193"
        ax.set_title(f"{app_short(app)}  {arrow}\n{eff:.2f}x", fontsize=8)
        ax.set_xlabel("")
        ax.set_ylabel(unit, fontsize=7.5)
        ax.set_xticks([0, 1])
        ax.set_xticklabels([f"base\nn={len(per['base'])}",
                            f"subsystem\nn={len(per['subsystem'])}"], fontsize=7)
        ax.tick_params(axis="y", labelsize=7)
        ax.grid(axis="x", visible=False)
    for ax in flat[len(panels):]:
        ax.axis("off")
    fig.tight_layout()
    save(fig, out, "all-apps")


def fig_amg(d, out, app="metric-amg2023"):
    """AMG2023: the cleanest measurement in the study, and the argument in one plot.

    Every run solved an identical 14.2M-unknown problem on 16 ranks, so nothing is
    confounded by launch shape. Repeat runs on one cluster agree to within about
    1%, and in the one replicate where both conditions landed on the same cluster
    they differ by 0.05%. Against that, the fastest cluster is 2.0 times the
    slowest. The measurement is quiet enough that placement is the only thing that
    moves it.

    Left: what each cluster delivers. Right: where each condition ended up. The
    base condition never reached the fastest cluster in ten attempts and lost four
    more to architecture mismatches.
    """
    rows = []
    for r in d["records"]:
        if r["app"] != app:
            continue
        f = ((r.get("fom") or {}).get("figure_of_merit") or {}).get("value")
        rows.append({"cluster": short(r["cluster"]) if r["cluster"] else "none",
                     "condition": r["condition"],
                     "fom": (f / 1e7) if f else None,
                     "ran": r["status"] == "ok"})
    if not rows:
        print("  (no amg data)")
        return
    df = pd.DataFrame(rows)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(7.2, 2.8),
                                   gridspec_kw={"width_ratios": [1.35, 1]})

    ok = df[df.fom.notna()]
    order = list(ok.groupby("cluster")["fom"].median().sort_values().index)
    sns.boxplot(data=ok, x="cluster", y="fom", hue="condition", palette=PAL,
                order=order, ax=ax1, showfliers=False, linewidth=0.8, width=0.7,
                boxprops={"alpha": 0.55}, dodge=True)
    sns.stripplot(data=ok, x="cluster", y="fom", hue="condition", palette=PAL,
                  order=order, ax=ax1, dodge=True, size=4, alpha=0.9, legend=False)
    ax1.set_xlabel("")
    ax1.set_ylabel("Figure of Merit ($10^7$ nnz/s)", fontsize=8)
    ax1.set_title("What each cluster delivers", fontsize=9)
    ax1.tick_params(axis="x", labelrotation=20, labelsize=7.5)
    for t in ax1.get_xticklabels():
        t.set_ha("right")
    ax1.tick_params(axis="y", labelsize=7.5)
    ax1.grid(axis="x", visible=False)
    ax1.legend(frameon=False, fontsize=7.5, loc="upper left")

    # where each condition went, failures included as their own category
    cats = order[::-1] + ["did not run"]
    counts = {c: {k: 0 for k in cats} for c in ("base", "subsystem")}
    for r in rows:
        counts[r["condition"]][r["cluster"] if r["ran"] else "did not run"] += 1
    bottom = {c: 0 for c in counts}
    greys = ["#3b6ea5", "#5b8fc9", "#8fb4dc", "#c2d5ea"]
    for i, cat in enumerate(cats):
        colour = "#b0b0b0" if cat == "did not run" else greys[i % len(greys)]
        for j, arm in enumerate(("base", "subsystem")):
            v = counts[arm][cat]
            ax2.bar(j, v, bottom=bottom[arm], color=colour, width=0.62,
                    edgecolor="white", linewidth=0.8,
                    label=cat if j == 0 else None)
            if v:
                ax2.text(j, bottom[arm] + v / 2, str(v), ha="center", va="center",
                         fontsize=7, color="white" if cat != "did not run" else "#333")
            bottom[arm] += v
    ax2.set_xticks([0, 1])
    ax2.set_xticklabels(["base", "subsystem"], fontsize=8)
    ax2.set_ylabel("Runs", fontsize=8)
    ax2.set_title("Where the jobs went", fontsize=9)
    ax2.set_ylim(0, 10.5)
    ax2.tick_params(axis="y", labelsize=7.5)
    ax2.grid(axis="x", visible=False)
    ax2.legend(frameon=False, fontsize=6.8, loc="upper center",
               bbox_to_anchor=(0.5, -0.13), ncol=2, columnspacing=0.9,
               handlelength=1.1)
    fig.tight_layout()
    save(fig, out, "amg")


def fig_sweep(d, out, app="osu-benchmark"):
    """A swept benchmark, both arms, every run.

    A single point cannot separate a real offset from one noisy measurement; a
    difference that holds across the whole sweep can only be the machine. This
    application also lost every matched pair — placement differed, but never with
    both arms surviving in the same replicate — so pooling by arm is the only way
    to see it at all.
    """
    per = collections.defaultdict(list)
    unit = "us"
    for r in d["records"]:
        if r["app"] != app:
            continue
        c = ((r.get("fom") or {}).get("curve") or {})
        if not c.get("value"):
            continue
        unit = c.get("unit") or unit
        for x, v in c["value"]:
            per[(r["condition"], x)].append(v)
    xs = sorted({x for _, x in per})
    if not xs:
        print(f"  (no curve data for {app})")
        return

    fig, ax = plt.subplots(figsize=(5.6, 3.2))
    for arm, colour, off in (("base", BASE, 0.96), ("subsystem", SUB, 1.04)):
        med, lo, hi, pts = [], [], [], []
        for x in xs:
            v = per[(arm, x)]
            if not v:
                med.append(None); lo.append(None); hi.append(None); continue
            med.append(statistics.median(v))
            lo.append(min(v)); hi.append(max(v))
            pts += [(x * off, y) for y in v]
        ax.plot([x * off for x in xs], med, "-o", color=colour, ms=4.5, lw=1.6,
                label=f"{arm} (median)", zorder=3)
        ax.vlines([x * off for x in xs], lo, hi, color=colour, lw=1.1, alpha=0.4,
                  zorder=1)
        if pts:
            ax.scatter([a for a, _ in pts], [b for _, b in pts], s=6,
                       color=colour, alpha=0.35, zorder=2)
    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xticks(xs)
    ax.set_xticklabels([str(x) for x in xs], rotation=45, ha="right")
    ax.set_xlabel("Message Size (bytes)")
    ax.set_ylabel(f"Latency ({unit})")
    ax.legend(frameon=False, loc="upper left")
    save(fig, out, "sweep")


def fig_agent(d, out):
    """What the agent contributed, and what happened when it was unavailable.

    Reported because it is a property of an agentic scheduler rather than a defect
    to engineer around: the deterministic fallback varies task layout only, so a
    failure needing an environment change cannot be recovered without the API.
    """
    recs = d["records"]
    lost = [r for r in recs if r.get("agent_lost") or
            (r.get("mode") and "fallback" in str(r["mode"]))]
    kept = [r for r in recs if r not in lost]
    groups = [("agent available", kept), ("agent unavailable", lost)]

    fig, ax = plt.subplots(figsize=(4.4, 2.5))
    x = range(len(groups))
    ok = [sum(1 for r in g if r["status"] == "ok") for _, g in groups]
    tot = [len(g) for _, g in groups]
    frac = [(o / t * 100 if t else 0) for o, t in zip(ok, tot)]
    ax.bar(list(x), frac, width=0.5, color=[SUB, BASE])
    for i, (o, t) in enumerate(zip(ok, tot)):
        ax.text(i, frac[i] + 2, f"{o}/{t}", ha="center", fontsize=8)
    ax.set_xticks(list(x))
    ax.set_xticklabels([f"{n}\n(n={len(g)})" for n, g in groups])
    ax.set_ylabel("Runs Executed (%)")
    ax.set_ylim(0, 105)
    ax.grid(axis="x", visible=False)
    save(fig, out, "agent")


def cmd_parse(argv) -> int:
    """Read the run directories and write dataset.json."""
    ap = argparse.ArgumentParser(prog="analyze parse", description=cmd_parse.__doc__)
    ap.add_argument("--runs", nargs="+", required=True,
                    help="one or more runs/ directories; several are replicates")
    ap.add_argument("--out", default="dataset.json")
    args = ap.parse_args(argv)

    records = []
    for i, d in enumerate(args.runs, start=1):
        if not os.path.isdir(d):
            print(f"skipping {d}: not a directory")
            continue
        got = parse_replicate(d, i)
        print(f"replicate {i}: {d} -> {len(got)} records")
        records += got

    if not records:
        print("no records found")
        return 2

    # The application output is the same text in every replicate, and ten copies of
    # it is most of the report's weight. Keep the first, and a tail for anything
    # that failed, since that is where the reason lives.
    seen = set()
    for r in records:
        key = (r["app"], r["condition"])
        if key in seen and r["status"] == "ok":
            r["stdout_tail"] = ""
            r["stderr_tail"] = ""
        seen.add(key)

    data = {"summary": summarise(records), "records": records}
    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, "w") as f:
        json.dump(data, f, indent=2)

    s = data["summary"]
    print()
    print(f"  replicates          {s['replicates']}")
    print(f"  records             {s['records']}")
    print(f"  placement differs   {s['placement_differs']}/{s['with_both_placements']}")
    print(f"  paired runtimes     {s['paired_runtimes']}")
    print(f"  median delta        {s['median_runtime_delta_s']}s")
    for cond, c in s["outcomes"].items():
        print(f"  {cond:10} {c}")
    print(f"\nwrote {args.out}")
    return 0


def cmd_figures(argv) -> int:
    """Read dataset.json and write the figures as SVG and PDF."""
    ap = argparse.ArgumentParser(prog="analyze figures", description=cmd_figures.__doc__)
    ap.add_argument("--data", default="dataset.json")
    ap.add_argument("--out", default="figures")
    ap.add_argument("--sweep-app", default="osu-benchmark")
    ap.add_argument("--exclude-cluster", default="sched-gke-bigmem",
                    help="clusters to drop entirely, comma separated. gke-bigmem "
                         "was never rebuilt to the fleet's node size and ran 32 "
                         "procs where every other cluster ran 16, so its rates are "
                         "not comparable. Empty string to keep everything.")
    args = ap.parse_args(argv)

    d = json.load(open(args.data))
    import copy
    full = copy.deepcopy(d)  # every cluster, for execution and placement
    drop = {c.strip() for c in args.exclude_cluster.split(",") if c.strip()}
    if drop:
        # Drop the runs, and any comparison that depended on one: a pair with a
        # missing arm is not a pair.
        bad = {(r["app"], r["replicate"]) for r in d["records"] if r["cluster"] in drop}
        n0 = len(d["records"])
        d["records"] = [r for r in d["records"] if r["cluster"] not in drop]
        d["summary"]["comparisons"] = [
            c for c in d["summary"]["comparisons"] if (c["app"], c["replicate"]) not in bad]
        print(f"excluded {', '.join(sorted(drop))}: "
              f"{n0 - len(d['records'])} runs, "
              f"{len(bad)} pair(s) dropped")

    # The figures only ever needed the records grouped by application. Building
    # that here rather than importing the report's aggregation keeps this file
    # standalone: parse and plot in one place, one dependency chain.
    views = {a: {"records": [r for r in d["records"] if r["app"] == a]}
             for a in sorted({r["app"] for r in d["records"]})}

    print(f"writing to {args.out}/")
    # Execution and placement keep every cluster. The exclusion below is about
    # comparing rates: gke-bigmem ran 32 processes where the others ran 16, which
    # makes a figure of merit incomparable but has no bearing on whether a job
    # started at all, nor on which cluster it was sent to.
    fig_execution(full, args.out)
    fig_placement(full, args.out)
    if any(app in views for app, *_ in BOXES) or any(
            r["app"] == "osu-benchmark" for r in d["records"]):
        fig_exemplars(d, args.out, views)
    fig_amg(d, args.out)
    fig_all_apps(d, args.out)
    fig_sweep(d, args.out, args.sweep_app)
    fig_agent(d, args.out)
    return 0


def main() -> int:
    argv = sys.argv[1:]
    cmds = {"parse": cmd_parse, "figures": cmd_figures}
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return 0
    if argv[0] == "all":
        # Parse then plot in one invocation. Each flag is routed to the step that
        # owns it, so a figure option does not reach the parser and vice versa.
        rest, data, figs = argv[1:], "dataset.json", "figures"
        FIGURE_FLAGS = ("--exclude-cluster", "--sweep-app")
        fig_args, parse_args, i = [], [], 0
        while i < len(rest):
            a = rest[i]
            if a == "--out-data":
                data = rest[i + 1]
                i += 2
            elif a == "--out":
                figs = rest[i + 1]
                i += 2
            elif a in FIGURE_FLAGS:
                fig_args += [a, rest[i + 1]]
                i += 2
            else:
                parse_args.append(a)
                i += 1
        rc = cmd_parse(parse_args + ["--out", data])
        return rc or cmd_figures(["--data", data, "--out", figs] + fig_args)
    if argv[0] not in cmds:
        print(f"unknown command {argv[0]!r}; expected parse, figures or all",
              file=sys.stderr)
        return 2
    return cmds[argv[0]](argv[1:])


if __name__ == "__main__":
    raise SystemExit(main())
