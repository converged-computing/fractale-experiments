#!/usr/bin/env bash
# Bring up the fleet.
#
#   PARALLEL=1 ./create-all.sh           all at once (what the experiment wants)
#   ./create-all.sh                      one at a time
#   ONLY="$C_GKE_CPU" ./create-all.sh    just one, for testing
#
# WHICH clusters are created comes from FLEET_CONTEXTS in env.sh, so this cannot
# drift from create-secret.sh, make-portable-kubeconfig.sh, register-all.sh and
# validate-fleet.sh. Add or drop a cluster there and every script follows.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

# Every cluster we know how to build. Only those in FLEET_CONTEXTS are created.
declare -A SCRIPT_FOR=(
  ["$C_GKE_CPU"]=./create-gke-cpu.sh
  ["$C_GKE_ARM"]=./create-gke-arm.sh
  ["$C_GKE_BIGMEM"]=./create-gke-bigmem.sh
  ["$C_GKE_MID"]=./create-gke-mid.sh
  ["$C_GKE_GPU"]=./create-gke-gpu.sh
  ["$C_GKE_GPU4"]=./create-gke-gpu-x4.sh
  ["$C_EKS_ARM_SMALL"]=./create-eks-arm-small.sh
  ["$C_EKS_ARM"]=./create-eks-arm-efa.sh
  ["$C_EKS_GPU1"]=./create-eks-gpu-nvidia.sh
  ["$C_EKS_GPU4"]=./create-eks-gpu-nvidia-x4.sh
  ["$C_EKS_AMD"]=./create-eks-gpu-amd.sh
  ["$C_EKS_BIGMEM"]=./create-eks-bigmem.sh
)

WANT=("${FLEET_CONTEXTS[@]}")
[ -n "${ONLY:-}" ] && WANT=($ONLY)

SCRIPTS=()
CONTEXTS=()
for ctx in "${WANT[@]}"; do
  s="${SCRIPT_FOR[$ctx]:-}"
  if [ -z "$s" ]; then
    echo "ERROR: no create script known for '$ctx'." >&2
    echo "       Add it to SCRIPT_FOR in create-all.sh." >&2
    exit 2
  fi
  if [ ! -f "$s" ]; then
    echo "ERROR: $s (for $ctx) does not exist" >&2
    exit 2
  fi
  SCRIPTS+=("$s")
  CONTEXTS+=("$ctx")
done

echo "== creating ${#SCRIPTS[@]} cluster(s)"
for i in "${!SCRIPTS[@]}"; do
  printf '   %-28s %s\n' "${CONTEXTS[$i]}" "${SCRIPTS[$i]}"
done
echo

failed=0
if [ "${PARALLEL:-0}" = "1" ]; then
  # Creation overlaps. Only the kubeconfig write is serialized, by
  # kubeconfig_write in env.sh: aws, gcloud and kubectl each read-modify-write
  # the same file with no locking of their own, and concurrent writes lose
  # entries.
  for s in "${SCRIPTS[@]}"; do
    echo "=== launching $s"
    bash "$s" > "logs-$(basename "$s" .sh).txt" 2>&1 &
  done
  # A bare `wait` discards exit statuses, so a failed create would be invisible.
  for job in $(jobs -p); do wait "$job" || failed=$((failed + 1)); done
  echo
  echo "all cluster scripts finished; see logs-*.txt"
else
  for s in "${SCRIPTS[@]}"; do
    echo "=== $s"
    bash "$s" || { echo "FAILED: $s (continuing)" >&2; failed=$((failed + 1)); }
  done
fi

[ "$failed" -eq 0 ] || echo "$failed script(s) returned non-zero" >&2

# The arm clusters need their arch taint gone and the arm operator image before
# anything can be dispatched to them. create-gke-arm.sh does this at creation; this
# repairs a cluster that came up without it, and is a no-op when there is nothing
# to fix.
if [ -x ./fix-arm-operator.sh ]; then
  echo
  echo "== arm clusters"
  ./fix-arm-operator.sh || echo "arm operator not ready; see above" >&2
fi

# Nothing downstream should read a kubeconfig that lost an entry: a cluster that
# exists but has no context is silently skipped by make-portable-kubeconfig.sh,
# and the experiment then runs against a smaller fleet than intended.
echo
echo "== contexts"
missing=0
for ctx in "${CONTEXTS[@]}"; do
  if kubectl config get-contexts -o name 2>/dev/null | grep -qx "$ctx"; then
    echo "   ok      $ctx"
  else
    echo "   MISSING $ctx" >&2
    missing=$((missing + 1))
  fi
done

echo
if [ "$failed" -eq 0 ] && [ "$missing" -eq 0 ]; then
  echo "all ${#CONTEXTS[@]} clusters created and in the kubeconfig."
  echo "next: ./validate-fleet.sh    (nodes, operator, device plugins)"
  exit 0
fi

echo "fleet is incomplete. ./validate-fleet.sh will say what is wrong." >&2
echo "Do not run the experiment until it reports the fleet ready: a partial" >&2
echo "fleet changes which placements are possible." >&2
exit 1
