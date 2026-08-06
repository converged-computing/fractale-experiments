#!/usr/bin/env bash
# Check every layer the experiment depends on, and exit non-zero if any is wrong.
#
#   ./validate-fleet.sh              # provider, kubeconfig, nodes, operator, devices
#   FLUXQ=http://localhost:8080 ./validate-fleet.sh    # also fluxq registration
#   SECRETARY_SECRET=flux-secretary-token ./validate-fleet.sh   # also the token
#
# A cluster that exists but has no operator, or is registered but unreachable,
# produces plausible results from a fleet that is not the one described. Every
# check below has caused that at least once.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

# Per-cluster expectations, keyed by context name. WHICH of these are checked
# comes from FLEET_CONTEXTS in env.sh, so the fleet is defined in exactly one
# place and a cluster dropped there is dropped everywhere.
#
#   cloud|region-or-zone|expected-nodes|gpu-resource|gpus-per-node
declare -A SPEC=(
  ["$C_GKE_CPU"]="gke|$GCP_ZONE|$FLEET_NODES|-|0"
  ["$C_GKE_MID"]="gke|$GCP_ZONE|$FLEET_NODES|-|0"
  ["$C_GKE_ARM"]="gke|$GCP_ZONE|$FLEET_NODES|-|0"
  ["$C_GKE_BIGMEM"]="gke|$GCP_ZONE|$FLEET_NODES|-|0"
  ["$C_GKE_GPU"]="gke|us-central1-c|3|nvidia.com/gpu|1"
  ["$C_GKE_GPU4"]="gke|$GCP_ZONE|2|nvidia.com/gpu|4"
  ["$C_EKS_ARM_SMALL"]="eks|us-east-1|$FLEET_NODES|-|0"
  ["$C_EKS_ARM"]="eks|$AWS_REGION_ARM|2|-|0"
  ["$C_EKS_GPU1"]="eks|$AWS_REGION_GPU|5|nvidia.com/gpu|1"
  ["$C_EKS_GPU4"]="eks|$AWS_REGION_GPU|2|nvidia.com/gpu|4"
  ["$C_EKS_AMD"]="eks|$AWS_REGION_GPU|3|amd.com/gpu|1"
  ["$C_EKS_BIGMEM"]="eks|$AWS_REGION_GPU|$FLEET_NODES|-|0"
)

FLEET=()
for ctx in "${FLEET_CONTEXTS[@]}"; do
  spec="${SPEC[$ctx]:-}"
  if [ -z "$spec" ]; then
    echo "ERROR: no expectations for '$ctx'; add it to SPEC in validate-fleet.sh" >&2
    exit 2
  fi
  FLEET+=("$ctx|$spec")
done

fail=0
note() { printf '    %s\n' "$1"; fail=$((fail + 1)); }

registered=""
if [ -n "${FLUXQ:-}" ]; then
  registered="$(curl -s --noproxy '*' "$FLUXQ/v1/clusters" 2>/dev/null)"
  [ -n "$registered" ] || echo "WARNING: $FLUXQ/v1/clusters returned nothing" >&2
fi

for row in "${FLEET[@]}"; do
  IFS='|' read -r ctx cloud loc want_nodes gpu_res want_gpus <<< "$row"
  echo "== $ctx"

  # 1. does the provider say it exists and is running
  case "$cloud" in
    gke)
      status="$(gcloud container clusters describe "$ctx" --project "$GCP_PROJECT" \
                  --zone "$loc" --format='value(status)' 2>/dev/null)"
      endpoint="$(gcloud container clusters describe "$ctx" --project "$GCP_PROJECT" \
                  --zone "$loc" --format='value(endpoint)' 2>/dev/null)"
      [ "$status" = "RUNNING" ] || note "provider status is '${status:-ABSENT}', want RUNNING"
      ;;
    eks)
      status="$(aws eks describe-cluster --region "$loc" --name "$ctx" \
                  --query 'cluster.status' --output text 2>/dev/null)"
      endpoint="$(aws eks describe-cluster --region "$loc" --name "$ctx" \
                  --query 'cluster.endpoint' --output text 2>/dev/null | sed 's|https://||')"
      [ "$status" = "ACTIVE" ] || note "provider status is '${status:-ABSENT}', want ACTIVE"
      # every nodegroup must be ACTIVE, not just the control plane
      for ng in $(aws eks list-nodegroups --region "$loc" --cluster-name "$ctx" \
                    --query 'nodegroups[]' --output text 2>/dev/null); do
        ngs="$(aws eks describe-nodegroup --region "$loc" --cluster-name "$ctx" \
                 --nodegroup-name "$ng" --query 'nodegroup.status' --output text 2>/dev/null)"
        [ "$ngs" = "ACTIVE" ] || note "nodegroup $ng is '$ngs', want ACTIVE"
      done
      ;;
  esac

  # 2. is it in the kubeconfig, pointing at the address the provider reports
  if kubectl config get-contexts -o name 2>/dev/null | grep -qx "$ctx"; then
    got="$(kubectl config view --minify --context "$ctx" \
             -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null | sed 's|https://||')"
    if [ -n "$endpoint" ] && [ "$got" != "$endpoint" ]; then
      note "kubeconfig points at '$got' but the provider says '$endpoint' (stale entry)"
    fi
  else
    note "not in \$KUBECONFIG ($KUBECONFIG)"
    echo
    continue
  fi

  # 3. can we reach it, and did the nodes join
  nodes="$(kubectl --context "$ctx" get nodes --no-headers --request-timeout=20s 2>/dev/null | wc -l)"
  ready="$(kubectl --context "$ctx" get nodes --no-headers --request-timeout=20s 2>/dev/null \
             | awk '$2=="Ready"' | wc -l)"
  if [ "$nodes" -eq 0 ]; then
    note "unreachable, or no nodes joined"
  elif [ "$ready" -ne "$want_nodes" ]; then
    note "$ready/$nodes nodes Ready, expected $want_nodes"
  fi

  # 4. the flux operator: a MiniCluster cannot be dispatched without it
  kubectl --context "$ctx" get crd miniclusters.flux-framework.org \
    --request-timeout=20s >/dev/null 2>&1 \
    || note "MiniCluster CRD missing (the operator was never installed)"
  rep="$(kubectl --context "$ctx" -n operator-system get deploy operator-controller-manager \
           -o jsonpath='{.status.readyReplicas}' --request-timeout=20s 2>/dev/null)"
  [ "${rep:-0}" -ge 1 ] 2>/dev/null || note "operator deployment not ready (readyReplicas=${rep:-0})"

  # 5. the device plugin: a pod only gets a GPU the node advertises
  if [ "$gpu_res" != "-" ]; then
    adv="$(kubectl --context "$ctx" get nodes -o jsonpath="{.items[0].status.allocatable['${gpu_res//./\\.}']}" \
             --request-timeout=20s 2>/dev/null)"
    if [ -z "$adv" ]; then
      note "$gpu_res not advertised (device plugin missing)"
    elif [ "$adv" != "$want_gpus" ]; then
      note "$gpu_res is $adv per node, expected $want_gpus"
    fi
  fi

  # 6. registered with fluxq, with the subsystems the experiment matches on
  if [ -n "$registered" ]; then
    if ! echo "$registered" | python3 -c "
import json,sys
d=json.load(sys.stdin)
cl=d.get('clusters',d) if isinstance(d,dict) else d
sys.exit(0 if any(c.get('name')=='$ctx' for c in cl) else 1)
" 2>/dev/null; then
      note "not registered with fluxq"
    else
      for sub in containment architecture memory network; do
        echo "$registered" | python3 -c "
import json,sys
d=json.load(sys.stdin)
cl=d.get('clusters',d) if isinstance(d,dict) else d
c=[x for x in cl if x.get('name')=='$ctx']
sys.exit(0 if c and '$sub' in (c[0].get('subsystems') or {}) else 1)
" 2>/dev/null || note "registered but subsystem '$sub' is missing"
      done
      if [ "$gpu_res" != "-" ]; then
        echo "$registered" | python3 -c "
import json,sys
d=json.load(sys.stdin)
cl=d.get('clusters',d) if isinstance(d,dict) else d
c=[x for x in cl if x.get('name')=='$ctx']
sys.exit(0 if c and 'gpu' in (c[0].get('subsystems') or {}) else 1)
" 2>/dev/null || note "registered but the gpu subsystem is missing"
      fi
    fi
  fi

  # 7. the agent token, only when the run intends to use it
  if [ -n "${SECRETARY_SECRET:-}" ]; then
    kubectl --context "$ctx" get secret "$SECRETARY_SECRET" \
      --request-timeout=20s >/dev/null 2>&1 \
      || note "secret $SECRETARY_SECRET missing"
  fi

  echo
done

echo "================================================================"
if [ "$fail" -eq 0 ]; then
  echo "fleet is ready: ${#FLEET[@]} clusters, every check passed"
  exit 0
fi
echo "$fail problem(s) found. Do NOT run the experiment: a partial fleet"
echo "changes which placements are possible, and the results would describe"
echo "a fleet that is not the one in the methods."
exit 1

# ---------------------------------------------------------------------------
# The invariant the experiment rests on: every cluster the same shape.
#
# Containment must not decide placement, and the agent sizes tasks to the cores
# it finds. A cluster with a different core count silently makes the two arms run
# different jobs, which is not visible in any per-cluster check above.
#
# hwloc counts cores; Kubernetes allocatable.cpu counts hardware threads. arm64
# parts have no SMT, so the expected vCPU differs by architecture even though the
# core count does not.
echo
echo "== uniform shape"
shape_bad=0
for ctx in "${FLEET_CONTEXTS[@]}"; do
  cpu="$(kubectl --context "$ctx" get nodes -o \
    jsonpath='{.items[0].status.allocatable.cpu}' --request-timeout=20s 2>/dev/null)"
  arch="$(kubectl --context "$ctx" get nodes -o \
    jsonpath='{.items[0].status.nodeInfo.architecture}' --request-timeout=20s 2>/dev/null)"
  n="$(kubectl --context "$ctx" get nodes --no-headers --request-timeout=20s 2>/dev/null | wc -l)"
  [ -n "$cpu" ] || { printf "   %-26s unreachable\n" "$ctx"; shape_bad=$((shape_bad+1)); continue; }

  # allocatable is a little under capacity, so round up to the nearest whole cpu
  vcpu="${cpu%m}"
  case "$cpu" in *m) vcpu=$(( (vcpu + 999) / 1000 ));; esac
  if [ "$arch" = "arm64" ]; then cores="$vcpu"; else cores=$(( vcpu / 2 )); fi

  status="ok"
  [ "$cores" -eq "$FLEET_CORES_PER_NODE" ] || { status="CORES $cores"; shape_bad=$((shape_bad+1)); }
  [ "$n" -eq "$FLEET_NODES" ] || { status="$status NODES $n"; shape_bad=$((shape_bad+1)); }
  printf "   %-26s %-6s %2s vcpu -> %s cores, %s nodes   %s\n" \
    "$ctx" "$arch" "$vcpu" "$cores" "$n" "$status"
done
if [ "$shape_bad" -ne 0 ]; then
  echo
  echo "The fleet is not uniform. Placement will be decided by containment and the" >&2
  echo "two arms will run different task counts, which makes the comparison invalid." >&2
  exit 1
fi
