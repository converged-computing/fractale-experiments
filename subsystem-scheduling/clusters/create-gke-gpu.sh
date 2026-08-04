#!/usr/bin/env bash
# amd64 / NVIDIA x1 / ethernet / 16-64GB  (the cross-cloud NVIDIA pair with EKS)
#
# Tries several accelerator and machine combinations across zones. L4 capacity in
# any one zone runs out, and the experiment does not care which NVIDIA part it
# gets: what it needs is a node with an nvidia device in the 16-64GB bucket.
#
# T4 attaches to n1 machines and is the most widely available; L4 needs g2, which
# is where the shortage usually is.
#
#   PARTS="n1-standard-8:nvidia-tesla-t4" ZONES="us-central1-b" ./create-gke-gpu.sh
set -uo pipefail
source "$(dirname "$0")/env.sh"

# machine:accelerator pairs, in order of preference. Each lands in 16-64GB:
#   g2-standard-8   32 GiB, L4
#   n1-standard-8   30 GiB, T4 or P4 or V100
#   n1-highmem-4    26 GiB, T4
PARTS="${PARTS:-g2-standard-8:nvidia-l4 n1-standard-8:nvidia-tesla-t4 n1-standard-8:nvidia-tesla-p4 n1-highmem-4:nvidia-tesla-t4 n1-standard-8:nvidia-tesla-v100}"
ZONES="${ZONES:-$GCP_ZONE us-central1-b us-central1-c us-central1-f}"
NODES="${NODES:-3}"

made=""
for zone in $ZONES; do
  for part in $PARTS; do
    machine="${part%%:*}"
    accel="${part##*:}"
    echo "== trying $machine with $accel in $zone"
    if gcloud container clusters create "$C_GKE_GPU" \
         --project "$GCP_PROJECT" --zone "$zone" \
         --machine-type "$machine" \
         --accelerator "type=${accel},count=1" \
         --num-nodes "$NODES" 2>&1 | tee /tmp/gkegpu.$$.log; then
      made="$machine with $accel in $zone"
      export GCP_ZONE="$zone"
      break 2
    fi
    gcloud container clusters delete "$C_GKE_GPU" --project "$GCP_PROJECT" \
      --zone "$zone" --quiet >/dev/null 2>&1
    grep -iE "quota|does not have enough resources|unsupported|not available|no valid" \
      /tmp/gkegpu.$$.log | head -2
  done
done
rm -f /tmp/gkegpu.$$.log

if [ -z "$made" ]; then
  echo "ERROR: no machine/accelerator pair in {$PARTS} was available in any of {$ZONES}" >&2
  echo "       Check GPU quota, which is per region AND per accelerator type:" >&2
  echo "         gcloud compute regions describe us-central1 \\" >&2
  echo "           --format='table(quotas.metric,quotas.limit,quotas.usage)' | grep -i gpu" >&2
  exit 1
fi
echo "== created with $made"

gke_kubeconfig "$C_GKE_GPU"

# GKE installs the driver via a daemonset. Without it the node has the device and
# advertises nothing, so a GPU job would be placed here and find nothing.
kubectl --context "$C_GKE_GPU" apply -f \
  https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml || true

check_gpu_plugin "$C_GKE_GPU" nvidia

# And confirm what the scheduler will actually see, since that is what the
# jobspecs match on.
echo "== advertised devices and memory:"
kubectl --context "$C_GKE_GPU" get nodes -o \
  custom-columns='NODE:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu,MEM:.status.allocatable.memory'
gpus="$(kubectl --context "$C_GKE_GPU" get nodes \
  -o jsonpath='{.items[0].status.allocatable.nvidia\.com/gpu}')"
if [ -z "$gpus" ] || [ "$gpus" = "0" ]; then
  echo "ERROR: the node advertises no nvidia.com/gpu, so a GPU job placed here" >&2
  echo "       would run without a device. The driver daemonset may still be" >&2
  echo "       starting: re-run check_gpu_plugin before registering." >&2
  exit 1
fi

install_flux_operator "$C_GKE_GPU" x86
register "$C_GKE_GPU" "$C_GKE_GPU"
