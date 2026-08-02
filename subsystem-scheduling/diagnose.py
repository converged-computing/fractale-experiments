#!/usr/bin/env python3
"""Why is a jobspec infeasible? Compare each requires dimension against what the
fleet actually advertises, and name the dimension(s) that no cluster satisfies.

    python3 diagnose.py
"""
import glob, json, os, sys, urllib.request

OPENER = urllib.request.build_opener(urllib.request.ProxyHandler({}))
FLUXQ = os.environ.get("FLUXQ", "http://localhost:8080")

with OPENER.open(f"{FLUXQ}/v1/clusters", timeout=15) as r:
    clusters = json.loads(r.read().decode())

print("FLEET ADVERTISES")
fleet = {}
for c in clusters:
    subs = c.get("subsystems") or {}
    print(f"  {c['name']:22} nodes={c.get('nodes')}  " +
          "  ".join(f"{k}={v}" for k, v in sorted(subs.items()) if k != "containment"))
    fleet[c["name"]] = {k: set(v) for k, v in subs.items()}

def values(section):
    """Flatten a requires section, expanding anyof."""
    out = set()
    for r in section or []:
        if r.get("type") == "anyof":
            out |= {w.get("type") for w in r.get("with", [])}
        else:
            out.add(r.get("type"))
    return out

print("\nPER JOBSPEC")
for f in sorted(glob.glob(os.path.join(os.path.dirname(os.path.abspath(__file__)), "jobspecs/*/jobspec.json"))):
    app = os.path.basename(os.path.dirname(f))
    js = json.load(open(f))
    req = js.get("requires") or {}
    res = js.get("resources", [{}])[0]
    nodes = res.get("count") if res.get("type") == "slot" else None
    gpu = "gpu" in json.dumps(res)
    blockers = []
    for dim, section in req.items():
        want = values(section)
        if not any(want & fleet[c].get(dim, set()) for c in fleet):
            blockers.append(f"{dim}={sorted(want)}")
    if gpu:
        blockers.append("containment: needs a GPU node")
    status = "OK" if not blockers else "BLOCKED by " + ", ".join(blockers)
    print(f"  {app:24} nodes={nodes} {status}")
