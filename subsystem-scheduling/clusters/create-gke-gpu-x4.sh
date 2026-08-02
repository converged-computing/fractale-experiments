#!/usr/bin/env bash
# amd64 / NVIDIA L4 x4 / ethernet / 192 GiB — the multi-GPU-per-node cluster
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_GPU4" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type g2-standard-48 \
  --accelerator "type=nvidia-l4,count=4,gpu-driver-version=default" \
  --num-nodes 2
gke_kubeconfig "$C_GKE_GPU4"
kubectl --context "$C_GKE_GPU4" apply -f \
  https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml || true
check_gpu_plugin "$C_GKE_GPU4" nvidia
install_flux_operator "$C_GKE_GPU4" x86
register "$C_GKE_GPU4" "$C_GKE_GPU4"
