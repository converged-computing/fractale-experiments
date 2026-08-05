#!/usr/bin/env bash
# amd64 / no GPU / ethernet / 192GB+ — the only GKE cluster in that memory bucket.
#
# Tries several machine families and zones. Capacity and quota in GCE are per zone
# AND per family, so the same request can fail all afternoon while a neighbouring
# zone or an AMD equivalent succeeds. What the experiment needs is a node in the
# 192GB+ bucket; which part provides it does not matter.
#
#   MACHINES="n2-highmem-32 n2d-highmem-32" ZONES="us-central1-a us-central1-b" ./create-gke-bigmem.sh
set -uo pipefail
source "$(dirname "$0")/env.sh"

# All 192GB+ and amd64. n2d is AMD EPYC and draws on a different quota pool than
# n2, which is usually the reason one works when the other does not.
MACHINES="${MACHINES:-$GKE_BIGMEM_MACHINES}"
ZONES="${ZONES:-$GKE_BIGMEM_ZONES}"
NODES="${NODES:-2}"

made=""
for zone in $ZONES; do
  for machine in $MACHINES; do
    echo "== trying $machine in $zone"
    if gcloud container clusters create "$C_GKE_BIGMEM" \
         --project "$GCP_PROJECT" --zone "$zone" \
         --machine-type "$machine" --num-nodes "$NODES" 2>&1 | tee /tmp/bigmem.$$.log; then
      made="$machine in $zone"
      export GCP_ZONE="$zone"   # gke_kubeconfig builds the context name from this
      break 2
    fi
    # A cluster can be left half created; remove it before trying the next part.
    gcloud container clusters delete "$C_GKE_BIGMEM" --project "$GCP_PROJECT" \
      --zone "$zone" --quiet >/dev/null 2>&1
    grep -iE "quota|does not have enough resources|unsupported|not available" \
      /tmp/bigmem.$$.log | head -2
  done
done
rm -f /tmp/bigmem.$$.log

if [ -z "$made" ]; then
  echo "ERROR: no machine type in {$MACHINES} was available in any of {$ZONES}" >&2
  echo "       Check quota: gcloud compute regions describe us-central1" >&2
  echo "       or set MACHINES/ZONES to something you have headroom for." >&2
  exit 1
fi
echo "== created with $made"

gke_kubeconfig "$C_GKE_BIGMEM"

# The bucket is what the jobspecs match on, so confirm the node really is 192GB+
# rather than assuming the machine type delivered it.
mem_kb="$(kubectl --context "$C_GKE_BIGMEM" get nodes \
  -o jsonpath='{.items[0].status.allocatable.memory}' | tr -d 'Ki')"
mem_gb=$(( mem_kb / 1048576 ))
echo "== allocatable memory: ${mem_gb} GiB"
if [ "$mem_gb" -lt 180 ]; then
  echo "ERROR: ${mem_gb} GiB is not the 192GB+ bucket the jobspecs ask for." >&2
  echo "       Allocatable is always below capacity, but not by this much." >&2
  exit 1
fi

install_flux_operator "$C_GKE_BIGMEM" x86
register "$C_GKE_BIGMEM" "$C_GKE_BIGMEM"
