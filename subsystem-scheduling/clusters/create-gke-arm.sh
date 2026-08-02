#!/usr/bin/env bash
# arm64 (Ampere Altra) / no GPU / ethernet / 32 GiB
#
# t2a is offered in a subset of zones (us-central1-a is one). Replaces the EKS
# Graviton clusters, whose nodegroups would not come up.
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters create "$C_GKE_ARM" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type t2a-standard-8 --num-nodes 3
gke_kubeconfig "$C_GKE_ARM"
install_flux_operator "$C_GKE_ARM" arm      # ARM manifest, not the x86 one
register "$C_GKE_ARM" "$C_GKE_ARM"
