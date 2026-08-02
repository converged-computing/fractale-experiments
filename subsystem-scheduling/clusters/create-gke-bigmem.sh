#!/usr/bin/env bash
# amd64 / no GPU / ethernet / 256 GiB — the only cluster in the 192GB+ bucket
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_BIGMEM" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type n2-highmem-32 --num-nodes 2
gke_kubeconfig "$C_GKE_BIGMEM"
install_flux_operator "$C_GKE_BIGMEM" x86
register "$C_GKE_BIGMEM" "$C_GKE_BIGMEM"
