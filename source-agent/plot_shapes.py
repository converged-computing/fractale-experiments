#!/usr/bin/env python3
"""Summarize and plot shape reports produced by `artifact-secretary shape`.

Standalone analysis: reads only the JSON artifacts, so it works on any sweep
after the fact. matplotlib is optional -- without it you still get the tables.

    ./plot_shapes.py shapes-20260813-0735/
    ./plot_shapes.py shapes-20260813-0735/ --outdir figures --tsv
    ./plot_shapes.py sweep/model-a sweep/model-b        # compare two sweeps

Handles reports written before run provenance existed: if an entry has no
`run.model`, the model is inferred from the directory name under the sweep root
(that is where the sweep script puts the model slug), and the focus from the
path segment after the revision.

Outputs
  runs.tsv           one row per run
  assertions.tsv     one row per assertion (the tidy table for any further work)
  coverage.png       which grammar fields each target asserted
  field_values.png   value distribution per field, across targets
  effort.png         source tokens and wall time per run
  confidence.png     confidence mix per field
  agreement.png      per-target agreement, when two sweeps are given
"""

from __future__ import annotations

import argparse
import collections
import json
import os
import re
import sys

VERSION = "2026-08-13.5"  # bumped when behaviour changes; shown in the footer

# ---------------------------------------------------------------- loading


def iter_reports(root: str):
    """Yield (path, entry) for every report under a tree or a single file.
    Unreadable files are skipped with a warning rather than aborting."""
    if os.path.isfile(root):
        paths = [root]
    else:
        paths = [
            os.path.join(cur, f)
            for cur, _d, files in os.walk(root)
            for f in files
            if f.endswith(".json")
        ]
    for path in sorted(paths):
        try:
            with open(path) as fh:
                doc = json.load(fh)
        except (OSError, json.JSONDecodeError) as e:
            print(f"warning: skipping {path} ({e})", file=sys.stderr)
            continue
        if "entry" in doc:  # written by save_tree
            entries = [doc["entry"]]
        else:  # a combined lookup (--out)
            entries = list((doc.get("entries") or {}).values())
        for entry in entries:
            if isinstance(entry, dict) and entry.get("repo"):
                yield path, entry


def infer_from_path(path: str, root: str) -> tuple[str, str]:
    """(model, focus) recovered from the tree layout, for reports written before
    run provenance existed. Layout is
    [<model-slug>/]<host>/<org>/<repo>/<revision>[/<focus>]/shapes.json.

    Anchored on the host segment (the one containing a dot, e.g. github.com)
    rather than a fixed depth, so this works whether `root` is the sweep root or
    a single model directory -- fixed offsets silently dropped the focus in the
    latter case and collapsed distinct focused runs onto one label."""
    try:
        rel = os.path.relpath(path, root)
    except ValueError:
        return "", ""
    parts = [p for p in rel.split(os.sep)[:-1] if p not in (".", "")]
    host = next((i for i, p in enumerate(parts) if "." in p and "/" not in p), None)
    if host is None:
        return "", ""
    model = parts[host - 1] if host >= 1 else ""
    # host, org, repo, revision, then optionally the focus
    focus = parts[host + 4] if len(parts) > host + 4 else ""
    return model, focus


def short_repo(repo: str) -> str:
    return repo.rstrip("/").split("/")[-1] or repo


def short_focus(focus: str, limit: int = 14) -> str:
    """Focus strings can be whole sentences ("osu_allreduce MPI_Allreduce
    collective benchmark"), which makes them useless as axis labels. Keep the
    first token-ish chunk, which is the part that identifies the variant."""
    if not focus:
        return ""
    first = focus.split()[0].strip(",:;")
    return first[:limit] if first else focus[:limit]


def family_of(field: str) -> str:
    return field.split(".")[0] if "." in field else field


def _app_key(target: str, focus: str, variant: str) -> str:
    """One identity per app VARIANT, named so the variant is obvious: a repo that
    yields a CPU build and a Kokkos/CUDA build is two entries, not one row that
    silently averages them. Models are NOT part of the key -- they belong side by
    side on the same page. See disambiguate_apps() for the collision guard."""
    tag = variant if variant and variant != "general" else short_focus(focus)
    return f"{target}:{tag}" if tag else target


def disambiguate_apps(assertions: list[dict]) -> None:
    """Guarantee one app identity per distinct (target, subject, variant) in place.

    _app_key alone can collide -- two subjects from one repo both carrying variant
    'general' would land on the same key and silently merge two different
    applications' shapes. Any key covering more than one (subject, variant) gets
    the subject folded into the name, so a collapse is impossible by construction
    rather than by luck of the naming."""
    seen = collections.defaultdict(set)
    for a in assertions:
        seen[a["app"]].add((a.get("subject", ""), a.get("variant", "")))
    ambiguous = {k for k, v in seen.items() if len(v) > 1}
    if not ambiguous:
        return
    for a in assertions:
        if a["app"] in ambiguous:
            subject = a.get("subject") or "?"
            variant = a.get("variant") or "general"
            base = a["app"].split(":")[0]
            a["app"] = f"{base}:{subject}:{variant}"


EVIDENCE_RX = re.compile(
    r"^(?P<path>[^\s:()]+):(?P<lines>\d+(?:\s*[-,]\s*\d+)*)\s*"
    r"(?:\((?P<comment>.*)\))?\s*$"
)


# Evidence sometimes carries the container-absolute clone path, e.g.
# "/tmp/artifact-secretary/repo/src/main.cc:243", because the agent read files
# through the in-container root. Those must be reduced to repo-relative or nothing
# resolves: git also refuses a sparse-checkout set containing a leading slash
# ("fatal: specify directories rather than patterns"), which silently left the
# whole checkout empty and made every snippet report "file not found".
_CLONE_PREFIXES = ("/tmp/artifact-secretary/repo/", "/tmp/artifact-secretary/")


def normalize_source_path(path: str) -> str:
    p = path.strip()
    for pre in _CLONE_PREFIXES:
        if p.startswith(pre):
            return p[len(pre):]
    if p.startswith("/"):
        # unknown absolute path: keep everything after a '/repo/' segment if there
        # is one, else drop the leading slash and hope it is repo-relative
        marker = "/repo/"
        if marker in p:
            return p.split(marker, 1)[1]
        return p.lstrip("/")
    return p[2:] if p.startswith("./") else p


def parse_evidence(ev: str) -> dict:
    """Split an evidence string into path, line span and the model's parenthetical
    note. Real evidence looks like
    'src/REAXFF/fix_qeq_reaxff.cpp:787-810 (per-iteration forward/reverse comm...)'
    so the note is part of the reasoning and worth surfacing, not discarding."""
    m = EVIDENCE_RX.match(ev.strip())
    if not m:
        return {"raw": ev, "path": "", "start": 0, "end": 0, "comment": ""}
    nums = [int(n) for n in re.findall(r"\d+", m.group("lines"))]
    return {
        "raw": ev,
        "path": normalize_source_path(m.group("path")),
        "start": min(nums) if nums else 0,
        "end": max(nums) if nums else 0,
        "comment": (m.group("comment") or "").strip(),
    }


def load(root: str) -> tuple[list[dict], list[dict]]:
    """(runs, assertions) as flat dict rows."""
    runs, assertions = [], []
    for path, entry in iter_reports(root):
        run = entry.get("run") or {}
        model, focus = run.get("model", ""), run.get("focus", "")
        if not model or not focus:
            gm, gf = infer_from_path(path, root)
            model = model or gm
            focus = focus or gf
        traces = entry.get("traces") or []
        budget = (entry.get("reads") or {}).get("budget") or {}
        n_assert = sum(
            len(s.get("assertions") or []) for t in traces for s in (t.get("shapes") or [])
        )
        target = short_repo(entry.get("repo", ""))
        label = f"{target}:{short_focus(focus)}" if focus else target
        runs.append(
            {
                "model": model,
                "target": target,
                "label": label,
                "focus": focus,
                "repo": entry.get("repo", ""),
                "commit": (entry.get("commit") or "unpinned")[:12],
                "traces": len(traces),
                "assertions": n_assert,
                "unmatched": sum(len(t.get("unmatched") or []) for t in traces),
                "source_tokens": budget.get("spent", 0) or 0,
                "duration_s": round(float(run.get("duration_s") or 0), 1),
                "status": "skipped" if entry.get("skipped") else "ok",
                "note": entry.get("skipped") or entry.get("notes") or "",
                "path": path,
            }
        )
        for t in traces:
            for shape in t.get("shapes") or []:
                for a in shape.get("assertions") or []:
                    ev = a.get("evidence") or []
                    assertions.append(
                        {
                            "model": model,
                            "target": target,
                            "label": label,
                            "repo": entry.get("repo", ""),
                            "commit": entry.get("commit", ""),
                            "subject": t.get("subject", ""),
                            "variant": t.get("variant", ""),
                            "app": _app_key(target, focus, t.get("variant", "")),
                            "trace_notes": t.get("notes", ""),
                            "trace_confidence": t.get("confidence", ""),
                            "shape_label": shape.get("label", ""),
                            "launch_command": shape.get("launch_command", ""),
                            "field": a.get("field", ""),
                            "value": a.get("value"),
                            "confidence": a.get("confidence", ""),
                            "evidence": [parse_evidence(e) for e in ev],
                            "evidence_count": len(ev),
                        }
                    )
    disambiguate_apps(assertions)
    return runs, assertions


# ---------------------------------------------------------------- tables


def write_tsv(rows: list[dict], path: str, columns: list[str]) -> None:
    with open(path, "w") as fh:
        fh.write("\t".join(columns) + "\n")
        for r in rows:
            fh.write("\t".join(str(r.get(c, "")) for c in columns) + "\n")
    print(f"  {path}")


def print_table(rows: list[dict], columns: list[str]) -> None:
    if not rows:
        print("  (nothing)")
        return
    w = {c: max(len(c), *(len(str(r.get(c, ""))) for r in rows)) for c in columns}
    print("  " + "  ".join(c.ljust(w[c]) for c in columns))
    print("  " + "  ".join("-" * w[c] for c in columns))
    for r in rows:
        print("  " + "  ".join(str(r.get(c, "")).ljust(w[c]) for c in columns))


def summarize(runs: list[dict], assertions: list[dict]) -> None:
    cols = [
        "model", "label", "commit", "traces", "assertions", "unmatched",
        "source_tokens", "duration_s", "status",
    ]
    runs = sorted(runs, key=lambda r: (r["model"], r["label"]))
    print("\n=== runs ===")
    print_table(runs, cols)
    for r in runs:
        if r["note"]:
            print(f"  note {r['label']}: {r['note']}")

    unpinned = [r for r in runs if r["commit"] == "unpinned"]
    if unpinned:
        print(
            f"\n  {len(unpinned)}/{len(runs)} runs are UNPINNED (no commit): those "
            "results cannot be tied to a revision."
        )

    print("\n=== assertions per field ===")
    by_field = collections.Counter(a["field"] for a in assertions)
    rows = [{"field": f, "count": n} for f, n in by_field.most_common()]
    print_table(rows, ["field", "count"])

    print("\n=== most common value per field ===")
    vals = collections.defaultdict(collections.Counter)
    for a in assertions:
        vals[a["field"]][json.dumps(a["value"])] += 1
    rows = [
        {
            "field": f,
            "values": ", ".join(f"{json.loads(v)}={n}" for v, n in c.most_common(4)),
        }
        for f, c in sorted(vals.items())
    ]
    print_table(rows, ["field", "values"])


# ---------------------------------------------------------------- plots


def plots(runs, assertions, outdir, compare=None, quiet=False):
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        print("\nmatplotlib not installed; skipping plots (pip install matplotlib)")
        return

    os.makedirs(outdir, exist_ok=True)
    models = sorted({r["model"] for r in runs if r["model"]}) or [""]
    width = 0.8 / max(1, len(models))

    def save(fig, name):
        path = os.path.join(outdir, name)
        fig.tight_layout()
        fig.savefig(path, dpi=140)
        plt.close(fig)
        if not quiet:
            print(f"  {path}")

    def fmt(v):
        if isinstance(v, list):
            return "+".join(str(x) for x in v)
        return str(v)

    # 1. per-target value matrix, ONE IMAGE PER FAMILY, cells coloured by the
    #    VALUE so distinct classifications are visually distinct (a single-hue
    #    heatmap made every asserted cell look identical). One legend per figure
    #    is enough because a family has few distinct values.
    from matplotlib.colors import ListedColormap
    from matplotlib.patches import Patch

    # stable colours for the values that recur across families, so e.g. "none"
    # always reads the same; anything else takes the next palette slot.
    FIXED = {
        "True": "#4c9f70", "False": "#d9dde2", "none": "#e8e8ea",
        "unknown": "#f0d9a8", "high": "#c1584f", "moderate": "#e9a13b",
        "low": "#8fb8de", "single_node": "#8fb8de", "multi_node": "#4a7fb5",
        "either": "#b9c9dc",
    }
    PALETTE = [
        "#4a7fb5", "#c1584f", "#4c9f70", "#e9a13b", "#8c6bb1", "#57a8a8",
        "#d17ba5", "#a3a3a3", "#7f9c3a", "#b5762f", "#6b8fd4", "#c25f8a",
    ]

    for model in models:
        rows = [a for a in assertions if a["model"] == model]
        if not rows:
            continue
        # keyed on the per-variant app, NOT the per-report label: three LAMMPS
        # reaxff variants must be three rows, or two of them are silently
        # overwritten by whichever is drawn last.
        labels = sorted({a["app"] for a in rows})
        by_family = collections.defaultdict(list)
        for a in rows:
            by_family[family_of(a["field"])].append(a)
        for fam, items in sorted(by_family.items()):
            fields = sorted({a["field"] for a in items})
            values = sorted({fmt(a["value"]) for a in items})
            # assign the fixed colours first, then fill the rest from the
            # palette SKIPPING hues already taken -- otherwise e.g. True and
            # neighbor both come out green and the colour tells you nothing.
            colours = {v: FIXED[v] for v in values if v in FIXED}
            used = set(colours.values())
            spare = [c for c in PALETTE if c not in used]
            for v in values:
                if v not in colours:
                    colours[v] = spare.pop(0) if spare else PALETTE[
                        len(colours) % len(PALETTE)
                    ]
            # index 0 is "not asserted"
            order = [None] + values
            cmap = ListedColormap(["#fbfbfc"] + [colours[v] for v in values])
            vi = {v: i + 1 for i, v in enumerate(values)}

            li = {l: i for i, l in enumerate(labels)}
            fi = {f: i for i, f in enumerate(fields)}
            grid = [[0] * len(fields) for _ in labels]
            text = [[""] * len(fields) for _ in labels]
            for a in items:
                r, c = li[a["app"]], fi[a["field"]]
                v = fmt(a["value"])
                grid[r][c] = vi[v]
                text[r][c] = v
            fig, ax = plt.subplots(
                figsize=(max(6, 2.1 * len(fields) + 4), max(3.5, 0.42 * len(labels) + 2.2))
            )
            ax.imshow(grid, aspect="auto", cmap=cmap, vmin=0, vmax=len(order) - 1)
            ax.set_xticks(range(len(fields)))
            ax.set_xticklabels(
                [f.split(".", 1)[-1].replace("_", "\n") for f in fields], fontsize=8
            )
            ax.set_yticks(range(len(labels)))
            ax.set_yticklabels(labels, fontsize=8)
            for r in range(len(labels)):
                for c in range(len(fields)):
                    if text[r][c]:
                        ax.text(c, r, text[r][c][:16], ha="center", va="center",
                                fontsize=7)
            ax.legend(
                handles=[Patch(facecolor=colours[v], label=v) for v in values],
                loc="upper left", bbox_to_anchor=(1.01, 1), fontsize=7,
                title="value", title_fontsize=7, frameon=False,
            )
            ax.set_title(f"{fam} — {model or 'all'}", fontsize=10)
            slug = (model or "all").replace(".", "-")
            save(fig, f"family_{fam}_{slug}.png")

    # 2. value distribution, faceted per field within a family (small multiples,
    #    each with its own axis) so no shared legend is needed at all.
    by_family = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
    for a in assertions:
        by_family[family_of(a["field"])][a["field"]][fmt(a["value"])] += 1
    for fam, fields in sorted(by_family.items()):
        names = sorted(fields)
        ncol = min(3, len(names))
        nrow = (len(names) + ncol - 1) // ncol
        fig, axes = plt.subplots(nrow, ncol, figsize=(4.2 * ncol, 3.0 * nrow))
        axes = [axes] if len(names) == 1 else list(
            axes.flat if hasattr(axes, "flat") else axes
        )
        for ax, field in zip(axes, names):
            counts = fields[field].most_common()
            vals = [v for v, _n in counts]
            ns = [n for _v, n in counts]
            ax.barh(range(len(vals)), ns, color="#4a7fb5")
            ax.set_yticks(range(len(vals)))
            ax.set_yticklabels([v[:24] for v in vals], fontsize=7)
            ax.invert_yaxis()
            ax.set_title(field, fontsize=9)
            ax.set_xlabel("apps", fontsize=8)
            for i, n in enumerate(ns):
                ax.text(n, i, f" {n}", va="center", fontsize=7)
        for ax in axes[len(names):]:
            ax.axis("off")
        fig.suptitle(f"value distribution — {fam}", fontsize=11)
        save(fig, f"values_{fam}.png")

    # 3. effort: SEPARATE images, one metric each. Two stacked panels with long
    #    rotated labels crushed both into unreadability.
    labels = sorted({r["label"] for r in runs})
    metrics = [("source_tokens", "source tokens served", "effort_tokens.png")]
    if any(r["duration_s"] for r in runs):
        metrics.append(("duration_s", "wall time (seconds)", "effort_duration.png"))
    else:
        print("    (no durations recorded in these reports; skipping that plot)")
    for key, ylab, fname in metrics:
        fig, ax = plt.subplots(figsize=(max(8, 0.55 * len(labels) + 3), 5))
        for mi, m in enumerate(models):
            per = {r["label"]: r for r in runs if r["model"] == m}
            ax.bar(
                [i + mi * width for i in range(len(labels))],
                [per.get(l, {}).get(key, 0) for l in labels],
                width=width,
                label=m or "(unknown)",
            )
        ax.set_xticks([i + 0.4 - width / 2 for i in range(len(labels))])
        ax.set_xticklabels(labels, rotation=45, ha="right", fontsize=8)
        ax.set_ylabel(ylab)
        ax.set_title(ylab + " per run", fontsize=10)
        ax.legend(fontsize=8)
        save(fig, fname)

    # 4. confidence mix per field
    conf = collections.defaultdict(collections.Counter)
    for a in assertions:
        conf[a["field"]][a["confidence"] or "unset"] += 1
    fields = sorted(conf)
    if fields:
        order = ["high", "medium", "low", "unset"]
        colors = {"high": "#2b6", "medium": "#fb3", "low": "#e44", "unset": "#999"}
        fig, ax = plt.subplots(figsize=(max(8, 0.42 * len(fields) + 3), 5))
        bottoms = [0] * len(fields)
        for level in order:
            heights = [conf[f].get(level, 0) for f in fields]
            if not any(heights):
                continue
            ax.bar(range(len(fields)), heights, bottom=bottoms, label=level,
                   color=colors[level])
            bottoms = [b + h for b, h in zip(bottoms, heights)]
        ax.set_xticks(range(len(fields)))
        ax.set_xticklabels(fields, rotation=45, ha="right", fontsize=7)
        ax.set_ylabel("assertions")
        ax.set_title("confidence mix per grammar field", fontsize=10)
        ax.legend(fontsize=8)
        save(fig, "confidence.png")

    # 5. agreement between two sweeps
    if compare:
        rows, _fields_diff = compare
        if rows:
            labels = [r["label"] for r in rows]
            fig, ax = plt.subplots(figsize=(max(8, 0.55 * len(labels) + 3), 5))
            ax.bar(labels, [r["agree"] for r in rows], label="agree", color="#2b6")
            ax.bar(labels, [r["differ"] for r in rows],
                   bottom=[r["agree"] for r in rows], label="differ", color="#e44")
            ax.bar(labels, [r["one_sided"] for r in rows],
                   bottom=[r["agree"] + r["differ"] for r in rows],
                   label="one side only", color="#999")
            ax.set_xticks(range(len(labels)))
            ax.set_xticklabels(labels, rotation=45, ha="right", fontsize=8)
            ax.set_ylabel("shared fields")
            ax.set_title("cross-sweep agreement per target", fontsize=10)
            ax.legend(fontsize=8)
            save(fig, "agreement.png")


# ---------------------------------------------------------------- source snippets


def fetch_sources(assertions, cache_dir, verbose=True):
    """Clone each referenced repo once (shallow, blobless) so evidence line spans
    can be shown as real code. The extraction container is long gone, so the only
    way to recover snippets after the fact is to fetch again.

    Where a report recorded a commit we check that exact revision out. Where it did
    not (an unpinned run) we take the default branch and MARK the snippet as
    possibly drifted -- line numbers from another revision can silently point at
    the wrong code, which would be worse than showing nothing.
    """
    import subprocess

    os.makedirs(cache_dir, exist_ok=True)
    repos = {}
    for a in assertions:
        if a.get("repo"):
            repos.setdefault(a["repo"], a.get("commit", ""))
    checkouts = {}
    for repo, commit in sorted(repos.items()):
        name = "_".join(repo.rstrip("/").split("/")[-2:]).replace(".git", "")
        dest = os.path.join(cache_dir, name)
        if not os.path.isdir(os.path.join(dest, ".git")):
            if verbose:
                print(f"  cloning {repo}")
            # blobless + no-checkout: LAMMPS costs ~4s/29MB this way rather than
            # a full clone. The sparse set is applied below.
            r = subprocess.run(
                ["git", "clone", "--quiet", "--filter=blob:none", "--no-checkout",
                 "--depth", "50", repo, dest],
                capture_output=True, text=True,
            )
            if r.returncode != 0:
                print(f"  warning: clone failed for {repo}: {r.stderr.strip()[:120]}",
                      file=sys.stderr)
                continue
            subprocess.run(["git", "-C", dest, "sparse-checkout", "init", "--cone"],
                           capture_output=True, text=True)

        # Reconcile the sparse set on EVERY run, not just on a fresh clone: a
        # cached repo keeps whatever directories the last run needed, so a newly
        # referenced file would silently be absent and its snippet lost.
        dirs = sorted({
            os.path.dirname(e["path"]) or "."
            for a in assertions if a.get("repo") == repo
            for e in (a.get("evidence") or []) if e.get("path")
        })
        # Only relative directories: git rejects the whole `set` call if any entry
        # has a leading slash, which would leave nothing checked out at all.
        wanted = {d for d in dirs if d and d != "." and not d.startswith("/")}
        root_files = any(d == "." for d in dirs)
        have = subprocess.run(["git", "-C", dest, "sparse-checkout", "list"],
                              capture_output=True, text=True)
        current = {d for d in have.stdout.split() if not d.startswith("/")} \
            if have.returncode == 0 else set()
        target = sorted(wanted | current)
        if target and (wanted - current):
            r = subprocess.run(
                ["git", "-C", dest, "sparse-checkout", "set", *target],
                capture_output=True, text=True,
            )
            if r.returncode != 0:
                # one bad entry should not cost every snippet: widen instead
                print(f"  warning: sparse set failed for {repo}, taking the whole "
                      f"tree ({r.stderr.strip()[:90]})", file=sys.stderr)
                subprocess.run(["git", "-C", dest, "sparse-checkout", "disable"],
                               capture_output=True, text=True)
        if root_files and target:
            # cone mode already includes the repo root, but be explicit when the
            # only evidence is a root file (stream.c, Makefile)
            subprocess.run(["git", "-C", dest, "sparse-checkout", "reapply"],
                           capture_output=True, text=True)
        subprocess.run(["git", "-C", dest, "checkout", "--quiet"],
                       capture_output=True, text=True)

        pinned = False
        if commit:
            r = subprocess.run(["git", "-C", dest, "checkout", "--quiet", commit],
                               capture_output=True, text=True)
            if r.returncode != 0:  # not in the shallow history; deepen once
                subprocess.run(["git", "-C", dest, "fetch", "--quiet", "--unshallow"],
                               capture_output=True, text=True)
                r = subprocess.run(["git", "-C", dest, "checkout", "--quiet", commit],
                                   capture_output=True, text=True)
            pinned = r.returncode == 0
            if not pinned:
                print(f"  warning: {repo} has no commit {commit[:12]}; using default "
                      "branch (snippets may have drifted)", file=sys.stderr)
        checkouts[repo] = {"path": dest, "pinned": pinned}
    return checkouts


_NAME_CACHE = {}


def _find_by_name(root, name, limit=20000):
    """Index a checkout once, then resolve a bare filename if it is unique."""
    if root not in _NAME_CACHE:
        idx = collections.defaultdict(list)
        seen = 0
        for cur, dirs, files in os.walk(root):
            dirs[:] = [d for d in dirs if d != ".git"]
            for f in files:
                idx[f].append(os.path.join(cur, f))
                seen += 1
                if seen > limit:
                    break
        _NAME_CACHE[root] = idx
    hits = _NAME_CACHE[root].get(name, [])
    return hits[0] if len(hits) == 1 else None


def read_snippet(checkout, path, start, end, pad=3, max_lines=40):
    """Return (lines, note). lines is a list of (number, text)."""
    if not checkout or not path or not start:
        return [], ""
    full = os.path.join(checkout["path"], path)
    if not os.path.isfile(full):
        # Last resort: the model may have cited a path relative to a subdirectory.
        # Resolve by filename if it is unambiguous, and say so, rather than
        # dropping the snippet entirely.
        hit = _find_by_name(checkout["path"], os.path.basename(path))
        if not hit:
            return [], f"{path} not found in this checkout"
        full = hit
        path_note = f"resolved by filename to {os.path.relpath(hit, checkout['path'])}"
    else:
        path_note = ""
    try:
        with open(full, errors="replace") as fh:
            content = fh.read().splitlines()
    except OSError as e:
        return [], f"unreadable ({e})"
    lo = max(1, start - pad)
    hi = min(len(content), (end or start) + pad)
    if hi - lo > max_lines:
        hi = lo + max_lines
    note = "" if checkout["pinned"] else (
        "unpinned: fetched from the default branch, lines may have drifted"
    )
    if path_note:
        note = f"{path_note}. {note}".strip()
    return [(n, content[n - 1]) for n in range(lo, hi + 1)], note


# ---------------------------------------------------------------- interactive


CSS = """
 body{font:14px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;
      margin:0;padding:22px 26px;color:#1b1b1f;background:#f7f8fa}
 a{color:#2b5f9e;text-decoration:none} a:hover{text-decoration:underline}
 h1{font-size:20px;margin:0 0 4px} h2{font-size:15px;margin:26px 0 10px}
 h3{font-size:13px;margin:18px 0 6px;color:#444}
 .sub{color:#666;font-size:13px;margin-bottom:16px}
 .bar{display:flex;gap:16px;flex-wrap:wrap;align-items:flex-end;margin-bottom:16px;
      background:#fff;padding:12px 14px;border:1px solid #e3e3e8;border-radius:8px}
 label{display:block;font-size:11px;text-transform:uppercase;letter-spacing:.05em;
       color:#666;margin-bottom:4px}
 select,input{font:13px inherit;padding:6px 8px;border:1px solid #ccc;border-radius:5px;
        background:#fff;min-width:150px}
 table{border-collapse:collapse;background:#fff;width:100%;
       border:1px solid #e3e3e8;border-radius:8px;overflow:hidden}
 th,td{padding:7px 10px;text-align:left;border-bottom:1px solid #eee;font-size:13px;
       vertical-align:top}
 th{background:#f1f3f6;font-size:11px;text-transform:uppercase;letter-spacing:.04em;
    color:#555}
 td.app{font-weight:600;white-space:nowrap}
 .v{display:inline-block;padding:1px 8px;border-radius:10px;font-size:12px;
    border:1px solid rgba(0,0,0,.12);white-space:nowrap}
 .mtag{font-size:10px;color:#777;margin-right:3px;font-family:ui-monospace,Menlo,monospace}
 .disagree{background:#fff4f4;outline:1px dashed #e0a0a0}
 .miss{color:#c4c4c8}
 .conf-low{box-shadow:0 0 0 2px #f0b4b4}
 .pill{display:inline-block;padding:1px 8px;border-radius:10px;font-size:11px;
       background:#eef2f8;border:1px solid #d6e0ee;color:#3a5b85;margin:0 6px 4px 0}
 .warn{background:#fff6e5;border:1px solid #f0dcb0;padding:8px 12px;border-radius:6px;
       font-size:12px;margin:10px 0}
 .card{background:#fff;border:1px solid #e3e3e8;border-radius:8px;padding:13px 15px;
       margin:10px 0}
 .field{font-weight:600;font-size:14px}
 .note{color:#444;font-size:13px;margin:6px 0;padding-left:10px;
       border-left:3px solid #d6e0ee;font-style:italic}
 pre{background:#1f2430;color:#e6e6e6;padding:9px 11px;border-radius:6px;
     overflow-x:auto;font:12px/1.45 ui-monospace,SFMono-Regular,Menlo,monospace;margin:7px 0}
 pre .ln{color:#7b8394;user-select:none}
 pre .hit{background:#39435a;display:block}
 .path{font:12px ui-monospace,Menlo,monospace;color:#555;margin-top:7px}
 .grid2{display:grid;grid-template-columns:repeat(auto-fit,minmax(330px,1fr));gap:14px}
 .hint{color:#777;font-size:12px}\n img{max-width:100%;height:auto;display:block}
 .nav{font-size:12px;color:#777;margin-bottom:12px}
 .tabs{display:flex;gap:4px;margin:0 0 14px;border-bottom:1px solid #dcdfe4}
 .tabs button{font:13px inherit;padding:8px 15px;border:1px solid transparent;
   border-bottom:none;background:none;color:#555;cursor:pointer;border-radius:6px 6px 0 0}
 .tabs button:hover{background:#eef1f5;color:#222}
 .tabs button.on{background:#fff;border-color:#dcdfe4;color:#1b1b1f;font-weight:600;
   margin-bottom:-1px}
 .panel{display:none} .panel.on{display:block}
 .cap{font:11px ui-monospace,Menlo,monospace;color:#777;margin-bottom:6px}
 img.zoom{cursor:zoom-in}
 #modal{position:fixed;inset:0;background:rgba(15,17,22,.88);display:none;z-index:99;
        padding:24px;box-sizing:border-box;overflow:auto}
 #modal.on{display:flex;align-items:center;justify-content:center}
 #modal img{max-width:98vw;max-height:92vh;background:#fff;border-radius:6px;
            box-shadow:0 8px 40px rgba(0,0,0,.5);cursor:zoom-out}
 #modal .close{position:fixed;top:14px;right:20px;color:#fff;font-size:26px;
               cursor:pointer;line-height:1;opacity:.85}
 #modal .cap2{position:fixed;bottom:14px;left:0;right:0;text-align:center;color:#dfe3ea;
              font:12px ui-monospace,Menlo,monospace}
"""


MODAL = """
<div id="modal" role="dialog" aria-label="enlarged figure">
  <span class="close" title="close (Esc)">&times;</span>
  <img id="modal-img" alt=""><div class="cap2" id="modal-cap"></div>
</div>
<script>
// Figures are small on the page and dense; clicking one opens it full size so a
// matrix or chart can actually be read. Delegated, so it also covers images
// inserted later by the tab rendering.
(function(){
  const m = document.getElementById("modal"),
        mi = document.getElementById("modal-img"),
        mc = document.getElementById("modal-cap");
  function open(src, cap){ mi.src = src; mc.textContent = cap || src;
                           m.classList.add("on"); }
  function close(){ m.classList.remove("on"); mi.src = ""; }
  document.addEventListener("click", e => {
    const img = e.target.closest("img");
    if (img && !img.closest("#modal")) {
      const card = img.closest(".card");
      const cap = card && card.querySelector(".cap") ? card.querySelector(".cap").textContent
                                                     : (img.alt || img.getAttribute("src"));
      open(img.getAttribute("src"), cap);
      return;
    }
    if (e.target.closest("#modal")) close();
  });
  document.addEventListener("keydown", e => { if (e.key === "Escape") close(); });
  // mark images as zoomable as they appear
  new MutationObserver(() => document.querySelectorAll("img:not(#modal-img)")
      .forEach(i => i.classList.add("zoom")))
    .observe(document.body, {childList: true, subtree: true});
  document.querySelectorAll("img:not(#modal-img)").forEach(i => i.classList.add("zoom"));
})();
</script>
"""


def _esc(t):
    return str(t).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


VALUE_COLORS = {
    "True": "#cfe9d8", "False": "#e4e7ea", "none": "#ebebed", "unknown": "#f7e6c4",
    "high": "#f0c9c5", "moderate": "#f7ddb8", "low": "#d3e3f3",
    "single_node": "#d3e3f3", "multi_node": "#bcd4ec", "either": "#e2eaf3",
}
_SPARE = ["#d7e3f4", "#f2d9e4", "#dcecdc", "#f6e7cf", "#e5dcf0", "#d5eceb",
          "#f0e0d0", "#e8e8f4", "#e3efd8", "#f4dcd6", "#dfe7f2", "#f1e2ea"]


def fmt_value(v):
    return "+".join(map(str, v)) if isinstance(v, list) else str(v)


def color_map(assertions):
    vals = sorted({fmt_value(a["value"]) for a in assertions})
    out, spare = {}, list(_SPARE)
    for v in vals:
        if v in VALUE_COLORS:
            out[v] = VALUE_COLORS[v]
    for v in vals:
        if v not in out:
            out[v] = spare.pop(0) if spare else "#eef2f8"
    return out


def field_slug(field):
    return "field_" + re.sub(r"[^A-Za-z0-9]", "_", field) + ".html"


def app_slug(app):
    return "app_" + re.sub(r"[^A-Za-z0-9._-]", "_", app) + ".html"


# ---------------------------------------------------------------- inline SVG


def svg_hbar(items, colors, width=420, row=20, label_w=150, title=""):
    """Horizontal bar chart as inline SVG: [(label, count)]. No JS, no libraries,
    so a page works from the filesystem and in a PDF print."""
    if not items:
        return ""
    mx = max(n for _l, n in items) or 1
    plot_w = width - label_w - 40
    h = row * len(items) + 26
    out = [f"<svg width='{width}' height='{h}' role='img'>"]
    if title:
        out.append(f"<text x='0' y='12' font-size='11' fill='#555'>{_esc(title)}</text>")
    for i, (lab, n) in enumerate(items):
        y = 22 + i * row
        w = max(2, int(n / mx * plot_w))
        c = colors.get(lab, "#cbd6e4")
        out.append(
            f"<text x='{label_w - 6}' y='{y + 11}' font-size='11' text-anchor='end' "
            f"fill='#333'>{_esc(lab[:22])}</text>"
            f"<rect x='{label_w}' y='{y + 2}' width='{w}' height='{row - 8}' rx='2' "
            f"fill='{c}' stroke='rgba(0,0,0,.15)'/>"
            f"<text x='{label_w + w + 5}' y='{y + 11}' font-size='10' fill='#666'>{n}</text>"
        )
    out.append("</svg>")
    return "".join(out)


def svg_shape_card(field_values, colors, width=470):
    """A compact picture of one app's whole shape: every asserted field grouped by
    family, coloured by value. Gives the page a visual summary before the detail."""
    fams = collections.defaultdict(list)
    for field, entries in sorted(field_values.items()):
        fams[family_of(field)].append((field, entries))
    rows = sum(len(v) for v in fams.values()) + len(fams)
    h = 16 * rows + 14
    out = [f"<svg width='{width}' height='{h}' role='img'>"]
    y = 12
    for fam, items in sorted(fams.items()):
        out.append(
            f"<text x='0' y='{y}' font-size='11' font-weight='600' fill='#333'>"
            f"{_esc(fam)}</text>"
        )
        y += 16
        for field, entries in items:
            short = field.split(".", 1)[-1].replace("_", " ")
            out.append(
                f"<text x='12' y='{y}' font-size='11' fill='#555'>{_esc(short[:22])}</text>"
            )
            x = 190
            for model, val in entries:
                v = fmt_value(val)
                w = 8 * len(v[:16]) + 14
                out.append(
                    f"<rect x='{x}' y='{y - 10}' width='{w}' height='14' rx='7' "
                    f"fill='{colors.get(v, '#eef2f8')}' stroke='rgba(0,0,0,.15)'/>"
                    f"<text x='{x + w / 2}' y='{y} ' font-size='10' text-anchor='middle' "
                    f"fill='#222'>{_esc(v[:16])}</text>"
                )
                x += w + 6
            y += 16
        y += 2
    out.append("</svg>")
    return "".join(out)


# ---------------------------------------------------------------- pages


INDEX_TEMPLATE = r"""<!doctype html>
<meta charset="utf-8"><title>shape explorer</title><style>__CSS__</style>
<h1>shape explorer</h1>
<div class="sub">__NAPPS__ app variants, __NRUNS__ runs, __NASSERT__ assertions.
One row per variant, with the variant named in its own column; models sit side by
side in each cell. Click an app for its evidence and source code, or a field name
for how that field breaks down across every app.</div>

<div class="tabs" id="tabs">
  <button data-tab="shapes" class="on">shapes</button>
  <button data-tab="family">family figures</button>
  <button data-tab="fields">field figures</button>
  <button data-tab="effort">effort &amp; confidence</button>
  <button data-tab="runs">runs</button>
</div>

<div class="bar" id="controls">
 <div><label>family</label><select id="fam"></select></div>
 <div><label>model</label><select id="model"></select></div>
 <div><label>filter apps</label><input id="q" placeholder="substring"></div>
</div>

<div class="panel on" id="p-shapes"><div id="grid"></div><div id="counts"></div></div>
<div class="panel" id="p-family"><div id="figs" class="grid2"></div></div>
<div class="panel" id="p-fields"><div id="ffigs" class="grid2"></div></div>
<div class="panel" id="p-effort"><div id="overview" class="grid2"></div></div>
<div class="panel" id="p-runs"><div id="runtable"></div></div>

<script>
const DATA = __DATA__, COLORS = __COLORS__, IMGS = __IMGS__, MODELS = __MODELS__;
const RUNS = __RUNS__;
const famOf = f => f.includes(".") ? f.split(".")[0] : f;
const fams = [...new Set(DATA.map(d => famOf(d.field)))].sort();
const models = [...new Set(DATA.map(d => d.model))].sort();
const famSel = document.getElementById("fam"), modelSel = document.getElementById("model");
fams.forEach(f => famSel.add(new Option(f, f)));
modelSel.add(new Option("all models", ""));
models.forEach(m => modelSel.add(new Option(m || "(unknown)", m)));
const fmt = v => Array.isArray(v) ? v.join("+") : String(v);
const colorOf = v => COLORS[fmt(v)] || "#eef2f8";
const shortModel = m => (m||"?").replace("us.anthropic.claude-","");
const appHref = a => "app_" + a.replace(/[^A-Za-z0-9._-]/g,"_") + ".html";
const fieldHref = f => "field_" + f.replace(/[^A-Za-z0-9]/g,"_") + ".html";

// tabs. The family/model/filter controls only apply to the first two panels, so
// hide them elsewhere rather than leaving dead inputs on screen.
let TAB = "shapes";
document.querySelectorAll("#tabs button").forEach(b => b.onclick = () => {
  TAB = b.dataset.tab;
  document.querySelectorAll("#tabs button").forEach(x => x.classList.toggle("on", x === b));
  document.querySelectorAll(".panel").forEach(p =>
    p.classList.toggle("on", p.id === "p-" + TAB));
  document.getElementById("controls").style.display =
    (TAB === "shapes" || TAB === "family") ? "flex" : "none";
  render();
});

function render(){
  const fam = famSel.value, model = modelSel.value;
  const q = document.getElementById("q").value.toLowerCase();
  let rows = DATA.filter(d => famOf(d.field) === fam);
  if (model) rows = rows.filter(d => d.model === model);
  if (q) rows = rows.filter(d => d.app.toLowerCase().includes(q));
  const fields = [...new Set(rows.map(d => d.field))].sort();
  const apps = [...new Set(rows.map(d => d.app))].sort();
  const cell = {};
  rows.forEach(d => { (cell[d.app+"|"+d.field] = cell[d.app+"|"+d.field] || []).push(d); });

  let h = "<table><thead><tr><th>app</th><th>variant</th>";
  fields.forEach(f => h += "<th><a href='"+fieldHref(f)+"'>"
      + f.split(".").slice(-1)[0].replace(/_/g," ") + "</a></th>");
  h += "</tr></thead><tbody>";
  apps.forEach(app => {
    const any = rows.find(d => d.app === app) || {};
    const base = app.includes(":") ? app.split(":")[0] : app;
    const variant = any.variant && any.variant !== "general" ? any.variant
                  : (app.includes(":") ? app.split(":").slice(1).join(":") : "default");
    h += "<tr><td class='app'><a href='"+appHref(app)+"'>"+base+"</a></td>"
       + "<td><span class='pill'>"+variant+"</span></td>";
    fields.forEach(f => {
      const ds = cell[app+"|"+f];
      if (!ds || !ds.length) { h += "<td class='miss'>&mdash;</td>"; return; }
      const vals = [...new Set(ds.map(d => fmt(d.value)))];
      const dis = vals.length > 1 ? "disagree" : "";
      let inner = "";
      if (vals.length === 1 && !model) {
        const d = ds[0];
        inner = "<span class='v"+(d.confidence==="low"?" conf-low":"")+"' style='background:"
              + colorOf(d.value) + "' title='models agree; confidence "+(d.confidence||"?")
              + "'>" + vals[0] + "</span>";
      } else {
        inner = ds.map(d => "<div><span class='mtag'>"+shortModel(d.model)+"</span>"
          + "<span class='v"+(d.confidence==="low"?" conf-low":"")+"' style='background:"
          + colorOf(d.value)+"'>"+fmt(d.value)+"</span></div>").join("");
      }
      h += "<td class='"+dis+"'>"+inner+"</td>";
    });
    h += "</tr>";
  });
  document.getElementById("grid").innerHTML = h + "</tbody></table>"
    + "<p class='hint'>&mdash; = nothing asserted. Pink cell = the models disagree. "
    + "Red outline = low confidence.</p>";

  let c = "<h2>value counts in this family</h2><div class='grid2'>";
  fields.forEach(f => {
    const counts = {};
    rows.filter(d => d.field === f).forEach(d => { const k=fmt(d.value); counts[k]=(counts[k]||0)+1; });
    const es = Object.entries(counts).sort((a,b)=>b[1]-a[1]);
    const max = Math.max(...es.map(e=>e[1]),1);
    c += "<div class='card'><div style='font-weight:600;font-size:13px;margin-bottom:6px'>"
       + "<a href='"+fieldHref(f)+"'>"+f+"</a></div>";
    es.forEach(([v,n]) => c += "<div style='display:flex;align-items:center;gap:8px;margin:3px 0'>"
      + "<span style='width:30px;text-align:right;color:#555;font-size:12px'>"+n+"</span>"
      + "<span style='height:13px;border-radius:3px;background:"+colorOf(v)+";width:"
      + (n/max*200)+"px;border:1px solid rgba(0,0,0,.12)'></span>"
      + "<span style='font-size:12px'>"+v+"</span></div>");
    c += "</div>";
  });
  document.getElementById("counts").innerHTML = c + "</div>";

  const want = IMGS.filter(n => n.startsWith("family_"+fam+"_") || n === "values_"+fam+".png");
  document.getElementById("figs").innerHTML = want.length
    ? want.map(n => "<div class='card'><div class='cap'>"+n+"</div><img src='img/"+n+"'></div>").join("")
    : "<div class='hint'>no figure for this family</div>";

  const ff = IMGS.filter(n => n.startsWith("field_"));
  document.getElementById("ffigs").innerHTML = ff.length
    ? ff.map(n => "<div class='card'><div class='cap'>"
        + n.replace(/^field_|\.png$/g,"").replace(/_/g,".")+"</div><img src='img/"+n+"'></div>").join("")
    : "<div class='hint'>no field figures</div>";

  const over = IMGS.filter(n => n.startsWith("effort_") || n === "confidence.png"
                             || n === "agreement.png");
  document.getElementById("overview").innerHTML = over.length
    ? over.map(n => "<div class='card'><div class='cap'>"+n+"</div><img src='img/"+n+"'></div>").join("")
    : "<div class='hint'>no overview figures</div>";

  const cols = ["model","label","commit","traces","assertions","unmatched",
                "source_tokens","duration_s","status"];
  let r = "<table><thead><tr>" + cols.map(c2 => "<th>"+c2.replace(/_/g," ")+"</th>").join("")
        + "</tr></thead><tbody>";
  RUNS.forEach(x => {
    const unpinned = x.commit === "unpinned" ? " style='color:#b3352b'" : "";
    r += "<tr>" + cols.map(c2 => "<td"+(c2==="commit"?unpinned:"")+">"+
      (c2==="model" ? shortModel(x[c2]) : x[c2]) + "</td>").join("") + "</tr>";
  });
  document.getElementById("runtable").innerHTML = r + "</tbody></table>"
    + "<p class='hint'>Red commit = unpinned: that report is not tied to a revision, "
    + "so its code snippets come from the default branch.</p>";
}
famSel.onchange = modelSel.onchange = render;
document.getElementById("q").oninput = render;
render();
</script>
__MODAL__
<p class="hint" style="margin-top:26px">generated by plot_shapes __VERSION__</p>
"""


def app_figure(app, rows, colors, imgdir):
    """A colourful per-app figure: every asserted field on the y axis, one column
    per model, cells filled with the value's colour. This is the visual summary
    the page leads with -- a wall of text does not show a shape."""
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        from matplotlib.colors import ListedColormap
        from matplotlib.patches import Patch
    except ImportError:
        return None

    models = sorted({r["model"] for r in rows})
    fields = sorted({r["field"] for r in rows})
    if not fields:
        return None
    values = sorted({fmt_value(r["value"]) for r in rows})
    vi = {v: i + 1 for i, v in enumerate(values)}
    cmap = ListedColormap(["#fbfbfc"] + [colors.get(v, "#eef2f8") for v in values])

    grid = [[0] * len(models) for _ in fields]
    text = [[""] * len(models) for _ in fields]
    fidx = {f: i for i, f in enumerate(fields)}
    midx = {m: i for i, m in enumerate(models)}
    for r in rows:
        i, j = fidx[r["field"]], midx[r["model"]]
        v = fmt_value(r["value"])
        grid[i][j] = vi[v]
        text[i][j] = v

    fig, ax = plt.subplots(
        figsize=(2.6 * len(models) + 4.5, max(3.0, 0.34 * len(fields) + 1.4))
    )
    ax.imshow(grid, aspect="auto", cmap=cmap, vmin=0, vmax=len(values))
    ax.set_xticks(range(len(models)))
    ax.set_xticklabels(
        [m.replace("us.anthropic.claude-", "") or "unknown" for m in models], fontsize=9
    )
    ax.set_yticks(range(len(fields)))
    ax.set_yticklabels(fields, fontsize=8)
    for i in range(len(fields)):
        for j in range(len(models)):
            if text[i][j]:
                ax.text(j, i, text[i][j][:18], ha="center", va="center", fontsize=8)
    # mark the rows where the models disagree -- the interesting ones
    for i, f in enumerate(fields):
        vals = {fmt_value(r["value"]) for r in rows if r["field"] == f}
        if len(vals) > 1:
            ax.get_yticklabels()[i].set_color("#b3352b")
            ax.get_yticklabels()[i].set_fontweight("bold")
    ax.set_title(f"{app} — derived shape (red = models disagree)", fontsize=10)
    fig.tight_layout()
    name = "app_" + re.sub(r"[^A-Za-z0-9._-]", "_", app) + ".png"
    fig.savefig(os.path.join(imgdir, name), dpi=140)
    plt.close(fig)
    return name


def field_figure(field, rows, colors, imgdir):
    """Per-field figure: value counts across apps, split by model, coloured by
    value so it matches the grid and the app pages."""
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        return None

    models = sorted({r["model"] for r in rows})
    values = sorted({fmt_value(r["value"]) for r in rows})
    counts = {m: collections.Counter(
        fmt_value(r["value"]) for r in rows if r["model"] == m) for m in models}

    fig, axes = plt.subplots(
        1, 2, figsize=(11, max(2.6, 0.4 * len(values) + 1.8)),
        gridspec_kw={"width_ratios": [1.15, 1]},
    )
    total = collections.Counter(fmt_value(r["value"]) for r in rows)
    ys = range(len(values))
    axes[0].barh(list(ys), [total[v] for v in values],
                 color=[colors.get(v, "#cbd6e4") for v in values],
                 edgecolor="#8895a6")
    axes[0].set_yticks(list(ys))
    axes[0].set_yticklabels(values, fontsize=9)
    axes[0].invert_yaxis()
    axes[0].set_xlabel("apps asserting this value", fontsize=9)
    axes[0].set_title(f"{field} across apps", fontsize=10)
    for i, v in enumerate(values):
        axes[0].text(total[v], i, f" {total[v]}", va="center", fontsize=8)

    width = 0.8 / max(1, len(models))
    for mi, m in enumerate(models):
        axes[1].bar(
            [i + mi * width for i in range(len(values))],
            [counts[m][v] for v in values],
            width=width, label=m.replace("us.anthropic.claude-", "") or "unknown",
            edgecolor="#8895a6",
        )
    axes[1].set_xticks([i + 0.4 - width / 2 for i in range(len(values))])
    axes[1].set_xticklabels(values, rotation=30, ha="right", fontsize=8)
    axes[1].set_ylabel("apps", fontsize=9)
    axes[1].set_title("by model", fontsize=10)
    axes[1].legend(fontsize=8)
    fig.tight_layout()
    name = "field_" + re.sub(r"[^A-Za-z0-9]", "_", field) + ".png"
    fig.savefig(os.path.join(imgdir, name), dpi=140)
    plt.close(fig)
    return name


def app_page(app, rows, colors, checkouts, snippets=True, figure=None):
    """One page per app variant, covering every model: a visual shape summary, the
    model's own commentary, then each assertion with the code it stands on."""
    first = rows[0]
    models = sorted({r["model"] for r in rows})
    by_field = collections.defaultdict(list)
    for r in rows:
        by_field[r["field"]].append((r["model"], r["value"]))

    parts = [
        "<!doctype html><meta charset='utf-8'>",
        f"<title>{_esc(app)}</title><style>{CSS}</style>",
        "<div class='nav'><a href='index.html'>&larr; all apps</a></div>",
        f"<h1>{_esc(app)}</h1>",
        "<div class='sub'>"
        + f"<span class='pill'>{_esc(first.get('repo', ''))}</span>"
        + f"<span class='pill'>commit {_esc((first.get('commit') or 'unpinned')[:12])}</span>"
        + f"<span class='pill'>subject {_esc(first.get('subject', ''))}</span>"
        + f"<span class='pill'>variant {_esc(first.get('variant', ''))}</span>"
        + "".join(f"<span class='pill'>{_esc(m)}</span>" for m in models)
        + f"<span class='pill'>{len(rows)} assertions</span></div>",
    ]
    if not first.get("commit"):
        parts.append(
            "<div class='warn'>This run is <b>unpinned</b> (no commit recorded), so the "
            "snippets below come from the current default branch and their line numbers "
            "may no longer match what the model actually read.</div>"
        )

    parts.append("<h2>shape at a glance</h2><div class='card'>")
    if figure:
        parts.append(f"<img src='img/{figure}' alt='derived shape for {_esc(app)}'>")
    parts.append(svg_shape_card(by_field, colors))
    parts.append("</div>")

    # the model's own prose, per model
    for m in models:
        notes = [r["trace_notes"] for r in rows if r["model"] == m and r.get("trace_notes")]
        launch = [r["launch_command"] for r in rows if r["model"] == m and r.get("launch_command")]
        lab = [r["shape_label"] for r in rows if r["model"] == m and r.get("shape_label")]
        if notes or launch or lab:
            parts.append(f"<h3>{_esc(m)} — what the model said</h3><div class='card'>")
            if lab:
                parts.append(f"<div><b>{_esc(lab[0])}</b></div>")
            if notes:
                parts.append(f"<div class='note'>{_esc(notes[0])}</div>")
            if launch:
                parts.append(
                    f"<pre style='background:#f4f5f7;color:#222'>{_esc(launch[0])}</pre>"
                )
            parts.append("</div>")

    parts.append("<h2>assertions and their evidence</h2>")
    for field in sorted(by_field):
        frows = [r for r in rows if r["field"] == field]
        vals = {fmt_value(r["value"]) for r in frows}
        parts.append("<div class='card'>")
        head = (
            f"<span class='field'><a href='{field_slug(field)}'>{_esc(field)}</a></span> "
        )
        for r in frows:
            v = fmt_value(r["value"])
            head += (
                f"<span class='mtag'>{_esc(r['model'].replace('us.anthropic.claude-', ''))}</span>"
                f"<span class='v' style='background:{colors.get(v, '#eef2f8')}'>{_esc(v)}</span> "
                f"<span class='pill'>{_esc(r.get('confidence') or '?')}</span> "
            )
        if len(vals) > 1:
            head += "<span class='pill' style='background:#fff4f4;border-color:#e0a0a0;color:#a33'>models disagree</span>"
        parts.append(f"<div>{head}</div>")
        seen_ev = set()
        for r in frows:
            for ev in r.get("evidence") or []:
                key = ev.get("raw", "")
                if key in seen_ev:
                    continue
                seen_ev.add(key)
                if ev.get("comment"):
                    parts.append(f"<div class='note'>{_esc(ev['comment'])}</div>")
                shown = ev.get("path") or key
                span = (
                    f":{ev['start']}"
                    + (f"-{ev['end']}" if ev.get("end") and ev["end"] != ev["start"] else "")
                ) if ev.get("start") else ""
                orig = (
                    f" <span class='hint'>(recorded as {_esc(key)})</span>"
                    if ev.get("path") and not key.startswith(ev["path"])
                    else ""
                )
                parts.append(f"<div class='path'>{_esc(shown)}{span}{orig}</div>")
                if snippets and ev.get("path"):
                    lines, note = read_snippet(
                        checkouts.get(r.get("repo", "")), ev["path"], ev["start"], ev["end"]
                    )
                    if lines:
                        lo, hi = ev["start"], ev["end"] or ev["start"]
                        body = "".join(
                            (
                                f"<span class='hit'><span class='ln'>{n:>5}</span>  {_esc(t)}</span>"
                                if lo <= n <= hi
                                else f"<span class='ln'>{n:>5}</span>  {_esc(t)}\n"
                            )
                            for n, t in lines
                        )
                        parts.append(f"<pre>{body}</pre>")
                    elif note:
                        parts.append(f"<div class='hint'>{_esc(note)}</div>")
        parts.append("</div>")
    parts.append(MODAL)
    return "\n".join(parts)


def field_page(field, rows, colors, figure=None):
    """One page per grammar field: how it breaks down across every app, as a chart
    plus a table linking back to the apps."""
    counts = collections.Counter(fmt_value(r["value"]) for r in rows)
    by_model = collections.defaultdict(collections.Counter)
    for r in rows:
        by_model[r["model"]][fmt_value(r["value"])] += 1
    by_conf = collections.Counter(r.get("confidence") or "unset" for r in rows)
    apps = sorted({r["app"] for r in rows})

    parts = [
        "<!doctype html><meta charset='utf-8'>",
        f"<title>{_esc(field)}</title><style>{CSS}</style>",
        "<div class='nav'><a href='index.html'>&larr; all apps</a></div>",
        f"<h1>{_esc(field)}</h1>",
        f"<div class='sub'>{len(rows)} assertions across {len(apps)} apps/variants."
        " Click an app to see the code behind its value.</div>",
    ]
    if figure:
        parts.append(f"<div class='card'><img src='img/{figure}' alt='{_esc(field)}'></div>")
    parts += [
        "<div class='grid2'>",
        "<div class='card'><h3>values across apps</h3>"
        + svg_hbar(counts.most_common(), colors)
        + "</div>",
        "<div class='card'><h3>confidence</h3>"
        + svg_hbar(
            by_conf.most_common(),
            {"high": "#cfe9d8", "medium": "#f7ddb8", "low": "#f0c9c5", "unset": "#e4e7ea"},
        )
        + "</div>",
    ]
    for m in sorted(by_model):
        parts.append(
            f"<div class='card'><h3>{_esc(m.replace('us.anthropic.claude-', '') or 'unknown')}</h3>"
            + svg_hbar(by_model[m].most_common(), colors)
            + "</div>"
        )
    parts.append("</div>")

    models = sorted({r["model"] for r in rows})
    parts.append("<h2>per app</h2><table><thead><tr><th>app / variant</th>")
    for m in models:
        parts.append(f"<th>{_esc(m.replace('us.anthropic.claude-', ''))}</th>")
    parts.append("<th>evidence</th></tr></thead><tbody>")
    for app in apps:
        parts.append(
            f"<tr><td class='app'><a href='{app_slug(app)}'>{_esc(app)}</a></td>"
        )
        ev_bits = []
        for m in models:
            hit = [r for r in rows if r["app"] == app and r["model"] == m]
            if not hit:
                parts.append("<td class='miss'>&mdash;</td>")
                continue
            v = fmt_value(hit[0]["value"])
            low = " conf-low" if hit[0].get("confidence") == "low" else ""
            parts.append(
                f"<td><span class='v{low}' style='background:{colors.get(v, '#eef2f8')}'>"
                f"{_esc(v)}</span></td>"
            )
            for e in hit[0].get("evidence") or []:
                if e.get("raw") not in ev_bits:
                    ev_bits.append(e.get("raw"))
        parts.append(
            "<td class='path'>" + "<br>".join(_esc(b) for b in ev_bits[:3]) + "</td></tr>"
        )
    parts.append("</tbody></table>")
    parts.append(MODAL)
    return "\n".join(parts)


def write_web(runs, assertions, outdir, fetch=True, cache_dir=".source-cache",
              compare=None, tsv=True):
    """Build the whole site under one directory: pages at the top level, every
    figure in img/, so the interface is self-contained and portable."""
    imgdir = os.path.join(outdir, "img")
    os.makedirs(imgdir, exist_ok=True)
    colors = color_map(assertions)

    checkouts = {}
    if fetch:
        print("  fetching sources (sparse) for snippets...")
        checkouts = fetch_sources(assertions, cache_dir)

    # global figures (family matrices, value distributions, effort, confidence)
    print("  figures ->", imgdir)
    plots(runs, assertions, imgdir, compare=compare, quiet=True)
    # field_* figures are written later (per field), so this list is refreshed
    # after those exist; app_* are per-page and never listed here.
    def _list_imgs():
        return sorted(
            f for f in os.listdir(imgdir)
            if f.endswith(".png") and not f.startswith("app_")
        )

    by_app = collections.defaultdict(list)
    for a in assertions:
        by_app[a["app"]].append(a)
    for app, rows in sorted(by_app.items()):
        fig = app_figure(app, rows, colors, imgdir)
        with open(os.path.join(outdir, app_slug(app)), "w") as fh:
            fh.write(app_page(app, rows, colors, checkouts, snippets=fetch, figure=fig))
    print(f"  {len(by_app)} app page(s)")

    by_field = collections.defaultdict(list)
    for a in assertions:
        by_field[a["field"]].append(a)
    for field, rows in sorted(by_field.items()):
        fig = field_figure(field, rows, colors, imgdir)
        with open(os.path.join(outdir, field_slug(field)), "w") as fh:
            fh.write(field_page(field, rows, colors, figure=fig))
    print(f"  {len(by_field)} field page(s)")

    if tsv:
        write_tsv(
            sorted(runs, key=lambda r: (r["model"], r["label"])),
            os.path.join(outdir, "runs.tsv"),
            ["model", "label", "repo", "commit", "traces", "assertions", "unmatched",
             "source_tokens", "duration_s", "status", "note"],
        )
        write_tsv(
            [{k: v for k, v in a.items() if k != "evidence"} for a in assertions],
            os.path.join(outdir, "assertions.tsv"),
            ["model", "app", "subject", "variant", "field", "value", "confidence",
             "evidence_count"],
        )

    global_imgs = _list_imgs()  # now includes the per-field figures
    grid = [
        {"app": a["app"], "model": a["model"], "field": a["field"],
         "value": a["value"], "confidence": a["confidence"],
         "evidence_count": a["evidence_count"],
         "variant": a.get("variant", ""), "subject": a.get("subject", "")}
        for a in assertions
    ]
    models = sorted({a["model"] for a in assertions})
    run_rows = [
        {
            "model": r["model"], "label": r["label"],
            "commit": r["commit"], "traces": r["traces"],
            "assertions": r["assertions"], "unmatched": r["unmatched"],
            "source_tokens": r["source_tokens"], "duration_s": r["duration_s"],
            "status": r["status"],
        }
        for r in sorted(runs, key=lambda r: (r["model"], r["label"]))
    ]
    html = (
        INDEX_TEMPLATE.replace("__CSS__", CSS)
        .replace("__MODAL__", MODAL)
        .replace("__VERSION__", VERSION)
        .replace("__DATA__", json.dumps(grid))
        .replace("__COLORS__", json.dumps(colors))
        .replace("__IMGS__", json.dumps(global_imgs))
        .replace("__MODELS__", json.dumps(models))
        .replace("__RUNS__", json.dumps(run_rows))
        .replace("__NRUNS__", str(len(runs)))
        .replace("__NAPPS__", str(len(by_app)))
        .replace("__NASSERT__", str(len(assertions)))
    )
    index = os.path.join(outdir, "index.html")
    with open(index, "w") as fh:
        fh.write(html)
    print(f"  {index}")


# ---------------------------------------------------------------- compare


def compare_sweeps(a_root, b_root):
    """Per-target agreement between two sweeps, plus which fields differ."""

    def index(root):
        _runs, asserts = load(root)
        out = collections.defaultdict(dict)
        for a in asserts:
            out[a["app"]][(a["subject"], a["variant"], a["field"])] = json.dumps(
                a["value"], sort_keys=True
            )
        return out

    ia, ib = index(a_root), index(b_root)
    rows, field_diffs = [], collections.Counter()
    for label in sorted(set(ia) | set(ib)):
        fa, fb = ia.get(label, {}), ib.get(label, {})
        shared = set(fa) & set(fb)
        differ = sorted(k for k in shared if fa[k] != fb[k])
        field_diffs.update(k[2] for k in differ)
        rows.append(
            {
                "label": label,
                "agree": len(shared) - len(differ),
                "differ": len(differ),
                "one_sided": len(set(fa) ^ set(fb)),
                "fields": ", ".join(sorted({k[2] for k in differ})),
                "details": [(k, fa[k], fb[k]) for k in differ],
            }
        )
    return rows, field_diffs


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("root", help="sweep root, model directory, or a single shapes.json")
    ap.add_argument("compare_to", nargs="?", help="second sweep to compare against")
    ap.add_argument("--web", default="web", help="output directory (pages + img/)")
    ap.add_argument(
        "--no-fetch-source",
        action="store_true",
        help="skip cloning repos; pages then show evidence paths but no code",
    )
    ap.add_argument(
        "--cache-dir", default=".source-cache", help="where fetched repos are kept"
    )
    ap.add_argument("-v", "--verbose", action="store_true", help="show each difference")
    args = ap.parse_args()

    print(f"plot_shapes {VERSION}")
    runs, assertions = load(args.root)
    if not runs:
        print(f"no reports found under {args.root}", file=sys.stderr)
        return 1
    print(f"loaded {len(runs)} run(s), {len(assertions)} assertion(s) from {args.root}")
    summarize(runs, assertions)

    cmp_data = None
    if args.compare_to:
        rows, field_diffs = compare_sweeps(args.root, args.compare_to)
        cmp_data = (rows, field_diffs)
        print(f"\n=== agreement: {args.root}  vs  {args.compare_to} ===")
        print_table(rows, ["label", "agree", "differ", "one_sided", "fields"])
        tot_a = sum(r["agree"] for r in rows)
        tot_d = sum(r["differ"] for r in rows)
        tot_o = sum(r["one_sided"] for r in rows)
        print(f"\n  agree={tot_a}  differ={tot_d}  one-side-only={tot_o}")
        if field_diffs:
            print(
                "  fields that differ most: "
                + ", ".join(f"{k}({n})" for k, n in field_diffs.most_common(10))
            )
        if args.verbose:
            for r in rows:
                for (subj, var, field), va, vb in r["details"]:
                    print(f"    {r['label']} {subj}:{var} {field}: {va} vs {vb}")

    print("\n=== building site ===")
    write_web(
        runs, assertions, args.web,
        fetch=not args.no_fetch_source,
        cache_dir=args.cache_dir,
        compare=cmp_data,
    )
    print(f"\nopen {os.path.join(args.web, 'index.html')}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
