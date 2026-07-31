#!/usr/bin/env bash
# amd64 / no GPU / ethernet / small memory  (e2-standard-4, 16 GiB)
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_CPU" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type e2-standard-4 --num-nodes 5
gcloud container clusters get-credentials "$C_GKE_CPU" --project "$GCP_PROJECT" --zone "$GCP_ZONE"
rename_context "gke_${GCP_PROJECT}_${GCP_ZONE}_${C_GKE_CPU}" "$C_GKE_CPU"
install_flux_operator "$C_GKE_CPU" x86
register "$C_GKE_CPU" "$C_GKE_CPU"
