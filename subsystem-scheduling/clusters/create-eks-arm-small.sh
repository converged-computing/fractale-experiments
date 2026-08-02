#!/usr/bin/env bash
# arm64 test cluster (~$0.32/hr all in). Pairs with sched-gke-cpu to give a real
# `architecture` dimension so the base-vs-subsystem difference is observable.
set -euo pipefail
source "$(dirname "$0")/env.sh"
CTX="$C_EKS_ARM_SMALL"
eksctl_create "$(dirname "$0")/eks-arm-small.yaml" "$CTX" us-east-1
# `aws eks update-kubeconfig` is the reliable path (eksctl's own
# write-kubeconfig often does not stick); --alias names the context.
kubeconfig_write aws eks update-kubeconfig --region us-east-1 --name "$CTX" --alias "$CTX"
install_flux_operator "$CTX" arm      # ARM manifest
echo "==> created $CTX; now: ./make-portable-kubeconfig.sh && ./register-all.sh $CTX"
