#!/usr/bin/env python3
"""
Summarize translation issues from data.json by experiment and issue type.
Flags are extracted directly from issue messages via regex rather than
keyword heuristics — e.g. '--mem-per-cpu', '-C', '--gres', '%j', etc.
"""

import json
import re
import sys
from collections import defaultdict

# Matches:
#   --long-flag or --long-flag=value  (captured as the flag name only)
#   -X  single-letter flags
#   %j  SLURM format specifiers
#   backtick-quoted tokens like `--mem-per-cpu=...` or `#SBATCH --foo`
FLAG_RE = re.compile(
    r"""
    (?:
        '([^']+)'           |   # single-quoted token
        `([^`]+)`           |   # backtick-quoted token
        (--[\w][\w-]*)      |   # --long-flag
        (?<!\w)(-[A-Za-z])  |   # -X  (not preceded by word char)
        (%[a-zA-Z])             # %j, %N etc.
    )
    """,
    re.VERBOSE,
)

# Within a quoted token, pull out individual flags
INNER_FLAG_RE = re.compile(r"(--[\w][\w-]*|-[A-Za-z]|%[a-zA-Z])")


def extract_flags(message: str) -> list:
    flags = []
    for m in FLAG_RE.finditer(message):
        quoted = m.group(1) or m.group(2)  # single or backtick quoted
        if quoted:
            for inner in INNER_FLAG_RE.findall(quoted):
                flags.append(inner.split("=")[0])
        else:
            flag = m.group(3) or m.group(4) or m.group(5)
            if flag:
                flags.append(flag.split("=")[0])
    # deduplicate within a single message while preserving order
    seen, out = set(), []
    for f in flags:
        if f not in seen:
            seen.add(f)
            out.append(f)
    return out


# ── data collection ───────────────────────────────────────────────────────────

ISSUE_TYPES = ["MISSING", "NO_ANALOGOUS", "UNKNOWN_TO_ME"]


def collect(data):
    per_experiment = defaultdict(lambda: defaultdict(list))
    global_flags = defaultdict(lambda: defaultdict(int))

    for experiment, jobs in data.items():
        for job in jobs:
            job_id = job.get("id", "unknown")
            for issue in job.get("issues", []):
                if len(issue) < 2:
                    continue
                itype, msg = issue[0].strip(), issue[1].strip()
                if itype not in ISSUE_TYPES:
                    continue
                flags = extract_flags(msg)
                per_experiment[experiment][itype].append((job_id, flags, msg))
                for f in flags:
                    global_flags[itype][f] += 1

    return per_experiment, global_flags


# ── display helpers ───────────────────────────────────────────────────────────

WIDTH = 80


def sep(char="─"):
    print(char * WIDTH)


def wrap(text, indent=9, width=WIDTH):
    words, line, out = text.split(), "", []
    for w in words:
        if len(line) + len(w) + 1 > width - indent:
            out.append(" " * indent + line)
            line = w
        else:
            line = (line + " " + w).strip()
    if line:
        out.append(" " * indent + line)
    return "\n".join(out)


# ── report sections ───────────────────────────────────────────────────────────


def print_global(global_flags):
    sep("═")
    print("GLOBAL FLAG SUMMARY — most-implicated SLURM flags per issue type")
    sep("═")

    for itype in ISSUE_TYPES:
        flags = global_flags.get(itype, {})
        total = sum(flags.values())
        print(f"\n  [{itype}]  ({total} flag occurrences across all experiments)")
        if not flags:
            print("    (none)")
            continue
        ranked = sorted(flags.items(), key=lambda x: -x[1])
        max_cnt = ranked[0][1] if ranked else 1
        for flag, cnt in ranked:
            bar = "█" * cnt + "░" * (max_cnt - cnt)
            print(f"    {flag:<30}  {cnt:>4}  {bar}")
    print()


def print_per_experiment(per_experiment):
    sep("═")
    print("PER-EXPERIMENT BREAKDOWN")
    sep("═")

    for exp in sorted(per_experiment.keys()):
        by_type = per_experiment[exp]
        total = sum(len(v) for v in by_type.values())
        print(f"\n  Experiment : {exp}   ({total} issues total)")
        sep()

        for itype in ISSUE_TYPES:
            entries = by_type.get(itype, [])
            if not entries:
                continue

            flag_counts = defaultdict(int)
            for _, flags, _ in entries:
                for f in flags:
                    flag_counts[f] += 1

            print(f"  {itype}  ({len(entries)} issue(s))")

            if flag_counts:
                ranked = sorted(flag_counts.items(), key=lambda x: -x[1])
                for flag, cnt in ranked:
                    print(f"    * {flag:<28}  x{cnt}")
            else:
                print("    (no flags extracted)")

            for job_id, flags, msg in entries[:4]:
                short = "/".join(job_id.split("/")[-2:])
                flag_str = "  flags: " + ", ".join(flags) if flags else ""
                print(f"\n      [{short}]{flag_str}")
                print(wrap(msg))
            remaining = len(entries) - 4
            if remaining > 0:
                print(f"\n      ... and {remaining} more")
            print()

        sep()


def main():
    path = sys.argv[1]
    try:
        with open(path) as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: '{path}' not found.")
        sys.exit(1)

    per_experiment, global_flags = collect(data)
    print_global(global_flags)
    print_per_experiment(per_experiment)


if __name__ == "__main__":
    main()
