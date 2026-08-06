#!/usr/bin/env bash
# amd64 / no GPU / ethernet / 16-64GB
#
# The fleet needs more than one amd64 cluster a mid-memory job can land on. With
# only two, and one of them rarely chosen, "placement differed" reduced to a single
# destination and the arms differed in variance as much as in placement.
#
# e2-standard-16: 16 vCPU, 8 physical cores, 64 GiB, matching every other cluster.
set -uo pipefail
source "$(dirname "$0")/env.sh"

MACHINE="${MACHINE:-e2-standard-16}"
NODES="${NODES:-$FLEET_NODES}"

gcloud container clusters create "$C_GKE_MID" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type "$MACHINE" --num-nodes "$NODES" || exit 1

gke_kubeconfig "$C_GKE_MID"

# Confirm the shape rather than trusting the machine type: the resource set and
# the task count both come from what the node really reports.
kubectl --context "$C_GKE_MID" get nodes -o \
  custom-columns='NODE:.metadata.name,CPU:.status.allocatable.cpu,MEM:.status.allocatable.memory'

install_flux_operator "$C_GKE_MID" x86
register "$C_GKE_MID" "$C_GKE_MID"
