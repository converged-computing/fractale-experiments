#!/usr/bin/env bash
# Save what every cluster in the fleet actually is, as JSON.
#
# The methods section needs the fleet described from the clusters themselves and
# not from the create scripts: the fallback machine types mean a cluster may not be
# the part the script asked for, and allocatable is always below capacity.
#
#   ./save-nodes.sh              # writes fleet/<context>.json and fleet/summary.json
#   ./save-nodes.sh out-dir
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

OUT="${1:-fleet}"
mkdir -p "$OUT"

for ctx in "${FLEET_CONTEXTS[@]}"; do
  echo "== $ctx"
  # the whole node list, for anything wanted later
  if kubectl --context "$ctx" get nodes -o json --request-timeout=60s \
       > "$OUT/$ctx.json" 2>/dev/null && [ -s "$OUT/$ctx.json" ]; then
    n=$(python3 -c "import json;print(len(json.load(open('$OUT/$ctx.json'))['items']))")
    echo "   $n node(s) -> $OUT/$ctx.json"
  else
    echo "   ERROR: could not read nodes; is the context live?" >&2
    rm -f "$OUT/$ctx.json"
  fi
done

# one distilled record per cluster, which is what a methods table needs
python3 - "$OUT" "${FLEET_CONTEXTS[@]}" <<'PY'
import json, os, sys

out, contexts = sys.argv[1], sys.argv[2:]
fleet = []
for ctx in contexts:
    path = os.path.join(out, f"{ctx}.json")
    if not os.path.exists(path):
        fleet.append({"context": ctx, "error": "not readable"})
        continue
    items = json.load(open(path))["items"]
    if not items:
        fleet.append({"context": ctx, "error": "no nodes"})
        continue
    n0 = items[0]
    lbl = n0["metadata"].get("labels", {})
    alloc, cap = n0["status"]["allocatable"], n0["status"]["capacity"]

    def gib(v):
        v = str(v)
        for suffix, mult in (("Ki", 1 / 1048576), ("Mi", 1 / 1024), ("Gi", 1.0)):
            if v.endswith(suffix):
                return round(float(v[: -len(suffix)]) * mult, 1)
        return round(float(v) / 2**30, 1)

    gpu = next((k for k in alloc if k.endswith("/gpu")), None)
    fleet.append({
        "context": ctx,
        "nodes": len(items),
        "instance_type": lbl.get("node.kubernetes.io/instance-type"),
        "arch": lbl.get("kubernetes.io/arch"),
        "zone": lbl.get("topology.kubernetes.io/zone"),
        "region": lbl.get("topology.kubernetes.io/region"),
        # capacity is the machine, allocatable is what a pod can have, and the
        # resource set has to match the second
        "cpu_capacity": cap.get("cpu"),
        "cpu_allocatable": alloc.get("cpu"),
        "memory_capacity_gib": gib(cap.get("memory", 0)),
        "memory_allocatable_gib": gib(alloc.get("memory", 0)),
        "gpu_resource": gpu,
        "gpu_allocatable": alloc.get(gpu) if gpu else None,
        "kubelet": n0["status"]["nodeInfo"].get("kubeletVersion"),
        "os_image": n0["status"]["nodeInfo"].get("osImage"),
        "kernel": n0["status"]["nodeInfo"].get("kernelVersion"),
        "taints": [f"{t.get('key')}={t.get('value')}:{t.get('effect')}"
                   for t in (n0.get("spec", {}).get("taints") or [])],
    })

with open(os.path.join(out, "summary.json"), "w") as f:
    json.dump({"clusters": fleet}, f, indent=2)

hdr = f"{'context':26} {'instance':16} {'arch':6} {'zone':16} {'cpu':>7} {'mem GiB':>9} {'n':>2} gpu"
print()
print(hdr)
for c in fleet:
    if c.get("error"):
        print(f"{c['context']:26} {c['error']}")
        continue
    print(f"{c['context']:26} {str(c['instance_type']):16} {str(c['arch']):6} "
          f"{str(c['zone']):16} {str(c['cpu_allocatable']):>7} "
          f"{c['memory_allocatable_gib']:>9} {c['nodes']:>2} "
          f"{c['gpu_allocatable'] or '-'}")
    if c["taints"]:
        print(f"{'':26} taints: {', '.join(c['taints'])}")
print()
print(f"wrote {os.path.join(out, 'summary.json')}")
PY
