#!/usr/bin/env bash
# amd64 / NVIDIA L4 x1 / ethernet  (cross-cloud NVIDIA)
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_GPU" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type g2-standard-8 --accelerator "type=nvidia-l4,count=1" --num-nodes 3
gcloud container clusters get-credentials "$C_GKE_GPU" --project "$GCP_PROJECT" --zone "$GCP_ZONE"
rename_context "gke_${GCP_PROJECT}_${GCP_ZONE}_${C_GKE_GPU}" "$C_GKE_GPU"
# GKE installs the NVIDIA driver/plugin via a daemonset; verify before registering.
kubectl --context "$C_GKE_GPU" apply -f \
  https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml || true
check_gpu_plugin "$C_GKE_GPU" nvidia
install_flux_operator "$C_GKE_GPU" x86
register "$C_GKE_GPU" "$C_GKE_GPU"
