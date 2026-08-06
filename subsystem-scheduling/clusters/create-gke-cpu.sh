#!/usr/bin/env bash
# amd64 / no GPU / ethernet / small memory  (e2-standard-4, 16 GiB)
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_CPU" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type e2-highcpu-16 --num-nodes "${NODES:-$FLEET_NODES}"
gke_kubeconfig "$C_GKE_CPU"
install_flux_operator "$C_GKE_CPU" x86
register "$C_GKE_CPU" "$C_GKE_CPU"
