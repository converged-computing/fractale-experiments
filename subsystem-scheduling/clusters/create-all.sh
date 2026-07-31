#!/usr/bin/env bash
# Bring up the fleet. Comment out lines to deploy a single cluster for testing.
# PARALLEL=1 ./create-all.sh  brings them up simultaneously (what the experiment wants).
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

SCRIPTS=(
  ./create-gke-cpu.sh
  ./create-eks-arm-efa.sh
  ./create-eks-gpu-nvidia.sh
  ./create-eks-gpu-nvidia-x4.sh
  ./create-gke-gpu.sh
  ./create-eks-gpu-amd.sh
  ./create-eks-bigmem.sh
)

if [ "${PARALLEL:-0}" = "1" ]; then
  # Each script writes its own context then registers; kubeconfig writes are the
  # one shared resource, so serialize nothing else and let creation overlap.
  for s in "${SCRIPTS[@]}"; do
    echo "=== launching $s"; "$s" > "logs-$(basename "$s" .sh).txt" 2>&1 &
  done
  wait
  echo "all cluster scripts finished; see logs-*.txt"
else
  for s in "${SCRIPTS[@]}"; do echo "=== $s"; "$s" || echo "FAILED: $s (continuing)"; done
fi

echo; echo "registered clusters:"; curl -s "$FLUXQ/v1/clusters" | head -40
