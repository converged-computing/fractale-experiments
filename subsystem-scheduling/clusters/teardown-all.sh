#!/usr/bin/env bash
# Delete every cluster and clean its context out of the shared kubeconfig.
set -uo pipefail
cd "$(dirname "$0")"; source ./env.sh
gcloud container clusters delete "$C_GKE_CPU" --project "$GCP_PROJECT" --zone "$GCP_ZONE" -q || true
gcloud container clusters delete "$C_GKE_GPU" --project "$GCP_PROJECT" --zone "$GCP_ZONE" -q || true
eksctl delete cluster --name "$C_EKS_ARM"    --region "$AWS_REGION_ARM" || true
for c in "$C_EKS_GPU1" "$C_EKS_GPU4" "$C_EKS_AMD" "$C_EKS_BIGMEM"; do
  eksctl delete cluster --name "$c" --region "$AWS_REGION_GPU" || true
done
for c in "$C_GKE_CPU" "$C_GKE_GPU" "$C_EKS_ARM" "$C_EKS_GPU1" "$C_EKS_GPU4" "$C_EKS_AMD" "$C_EKS_BIGMEM"; do
  kubectl config delete-context "$c" >/dev/null 2>&1 || true
done
echo "fleet deleted; contexts removed from $KUBECONFIG"
