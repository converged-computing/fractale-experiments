#!/usr/bin/env bash
# arm64 (Ampere Altra) / no GPU / ethernet / 32 GiB
#
# t2a is offered in a subset of zones (us-central1-a is one). Replaces the EKS
# Graviton clusters, whose nodegroups would not come up.
set -euo pipefail
source "$(dirname "$0")/env.sh"

# --node-taints="" so GKE does not apply kubernetes.io/arch=arm64:NoSchedule.
# Our MiniClusters carry no tolerations, so that taint leaves the operator and
# every job Pending until the timeout, which reads as a scheduling failure
# instead of an unusable cluster.
gcloud container clusters create "$C_GKE_ARM" \
  --project "$GCP_PROJECT" --zone "$GCP_ZONE" \
  --machine-type t2a-standard-8 --num-nodes 3 \
  --node-taints=""

gke_kubeconfig "$C_GKE_ARM"

# Belt and braces: strip any arch taint that landed anyway before the operator
# is installed, or its rollout will never complete.
for n in $(kubectl --context "$C_GKE_ARM" get nodes -o name); do
  kubectl --context "$C_GKE_ARM" taint "$n" kubernetes.io/arch=arm64:NoSchedule- \
    >/dev/null 2>&1 || true
done
echo "==> taints on $C_GKE_ARM:"
kubectl --context "$C_GKE_ARM" get nodes \
  -o custom-columns='NODE:.metadata.name,TAINTS:.spec.taints'

install_flux_operator "$C_GKE_ARM" arm      # ARM manifest, not the x86 one

# install_flux_operator ends in `|| true`, so check for real: an operator that
# never becomes ready means nothing can be dispatched here.
if ! kubectl --context "$C_GKE_ARM" -n operator-system rollout status \
       deploy/operator-controller-manager --timeout=5m; then
  echo "ERROR: operator not ready on $C_GKE_ARM" >&2
  kubectl --context "$C_GKE_ARM" -n operator-system get pods
  kubectl --context "$C_GKE_ARM" -n operator-system describe pod \
    -l control-plane=controller-manager | sed -n '/Events:/,$p'
  exit 1
fi

register "$C_GKE_ARM" "$C_GKE_ARM"
