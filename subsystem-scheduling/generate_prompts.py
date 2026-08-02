#!/usr/bin/env python3
"""Generate frozen jobspec-authoring prompts for the subsystem-scheduling study.

For each unique application (grouped by container REPO, not the free-text
`application` field), draw a random size in [1..N] and freeze it into a prompt +
a fluxq-select run manifest. Feeding each to `fluxq select` twice — once against a
fleet WITH descriptive subsystems, once WITHOUT — is the experiment; the frozen
size guarantees the two runs use the identical jobspec.

Infrastructure containers (flux itself, base toolkit images) are dropped; the
prompt also instructs the agent to skip anything that isn't a real HPC/AI-ML app.

    python generate_prompts.py --manifests ../fluxq-manifests \
        --vocabulary vocabulary.json --out prompts --max-size 5 --seed 0
"""

import argparse
import json
import os
import random
from pathlib import Path

HERE = os.path.dirname(os.path.abspath(__file__))

# Container repos that are NOT benchmarkable applications (the "not like flux"
# infra + base toolkit images). Matched by substring on the repo name.
SKIP_REPO_SUBSTRINGS = ("flux-core", "flux-sched", "fluxion", "azurehpc")

# Variant tags that pin an unusable fabric for this fleet (no InfiniBand: EFA on
# AWS, ethernet on GCP). Heuristic — the manifest capability.fabric_* flags are
# not reliably populated, so we fall back to the tag. A variant is dropped; an
# app is only skipped if it has no usable variants left.
DROP_VARIANT_TAG_SUBSTRINGS = ("mellanox",)


def repo_of(reference):
    """ghcr.io/org/metric-lammps-cpu:tag -> metric-lammps-cpu"""
    return reference.split("@")[0].rsplit(":", 1)[0].rsplit("/", 1)[-1]


def tag_of(reference):
    body = reference.split("@")[0]
    return body.rsplit(":", 1)[1] if ":" in body.rsplit("/", 1)[-1] else "latest"


def load_by_repo(manifests_dir):
    """Group profiled variants by repo. Returns {repo: {subtree, variants:[...]}}."""
    apps = {}
    for path in Path(manifests_dir).rglob("manifest.json"):
        doc = json.loads(path.read_text())
        entry = doc.get("entry", doc)
        arts = entry.get("artifacts", [])
        if not arts:
            continue  # nothing profiled -> not a usable container
        ref = entry.get("reproduce", {}).get("reference", "")
        if not ref:
            continue
        repo = repo_of(ref)
        art = arts[0]
        apps.setdefault(repo, {"subtree": None, "variants": [], "_counts": {}})
        apps[repo]["variants"].append({
            "reference": ref, "tag": tag_of(ref), "arch": art.get("arch", ""),
            "application": art.get("application", ""), "capability": art.get("capability", {}),
        })
        # The repo's manifest subtree (parent of the tag dir) scopes a select run:
        # .../<repo>/<tag>/manifest.json -> .../<repo>
        # A repo can appear under more than one root (e.g. a stray duplicated
        # ghcr.io/ghcr.io tree). Count per subtree and keep the richest one, so the
        # agent always sees the full variant set rather than whichever was walked last.
        sub = str(path.parent.parent)
        apps[repo]["_counts"][sub] = apps[repo]["_counts"].get(sub, 0) + 1
    for app in apps.values():
        app["subtree"] = max(app["_counts"], key=app["_counts"].get)
        del app["_counts"]
    return apps


def usable(app):
    """Drop variants pinned to an unavailable fabric; keep the app if any remain."""
    kept = [v for v in app["variants"]
            if not any(s in v["tag"].lower() for s in DROP_VARIANT_TAG_SUBSTRINGS)]
    return kept


def prompt_text(repo, size):
    return f"""Generate exactly ONE fluxq jobspec for the application container "{repo}".

Target size: {size} node(s) — request exactly this many nodes.

Choose the best profiled variant for running this application well, and derive the
run command from the application itself (e.g. LAMMPS -> `lmp -in <input>`; an OSU
benchmark -> its benchmark binary), sized for {size} node(s).

Classify the jobspec's requires against the fleet vocabulary (call get_vocabulary):
- architecture and GPU vendor are stamped from the manifest — do NOT supply them.
- choose network fabric(s) only from the vocabulary's values, if the build wants one.
- estimate the memory RANGE (from the vocabulary) this app needs at {size} node(s),
  considering whether it could run out of memory on a small node.
- set gpus_per_node > 0 only if the chosen container is GPU-capable.
Never require the application itself (it is inside the container).

If "{repo}" is not a real HPC or AI/ML application (a base image, or flux
infrastructure), call skip_application instead of recording a jobspec."""


def main(argv=None):
    p = argparse.ArgumentParser(description="Generate frozen jobspec prompts.")
    p.add_argument("--manifests", default=os.path.join(HERE, "..", "fluxq-manifests"))
    p.add_argument("--vocabulary", default="vocabulary.json",
                   help="cached /v1/vocabulary output, derived once for the experiment")
    p.add_argument("--clusters", default="clusters.json",
                   help="cached /v1/clusters output (context for the agent)")
    p.add_argument("--out", default=os.path.join(HERE, "prompts"))
    p.add_argument("--max-size", type=int, default=5)
    p.add_argument("--seed", type=int, default=0, help="reproducible size draws")
    args = p.parse_args(argv)

    apps = load_by_repo(args.manifests)
    rng = random.Random(args.seed)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    index, skipped_infra = [], []
    for repo in sorted(apps):
        if any(s in repo for s in SKIP_REPO_SUBSTRINGS):
            skipped_infra.append(repo)
            continue
        variants = usable(apps[repo])
        if not variants:
            skipped_infra.append(repo + " (no usable-fabric variant)")
            continue
        size = rng.randint(1, args.max_size)
        app_dir = out / repo
        app_dir.mkdir(parents=True, exist_ok=True)
        goal = prompt_text(repo, size)
        (app_dir / "prompt.txt").write_text(goal + "\n")
        # a fluxq-select run manifest: scoped to THIS repo's subtree, frozen size
        run = {
            "manifests_dir": apps[repo]["subtree"],
            "vocabulary": args.vocabulary,
            "goal": goal,
            "out_dir": f"jobspecs/{repo}",
            "duration_s": 3600,
            "app": repo,
            "size": size,
        }
        (app_dir / "run.json").write_text(json.dumps(run, indent=2) + "\n")
        index.append({"app": repo, "size": size, "variants": len(variants)})

    (out / "index.json").write_text(json.dumps(
        {"apps": index, "skipped": skipped_infra, "seed": args.seed,
         "max_size": args.max_size}, indent=2) + "\n")
    print(f"wrote {len(index)} prompts to {out}/ (skipped {len(skipped_infra)} infra/unusable)")
    for e in index:
        print(f"  {e['app']:28} size={e['size']}  ({e['variants']} variants)")


if __name__ == "__main__":
    main()
