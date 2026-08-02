#!/usr/bin/env bash
# arm64 (Graviton3E) / no GPU / EFA / 128 GiB — uses the ARM flux-operator manifest
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl_create "$(dirname "$0")/eks-arm-efa.yaml" "$C_EKS_ARM" $AWS_REGION_ARM
# `aws eks update-kubeconfig` is the reliable path (eksctl's own
# write-kubeconfig often does not stick); --alias names the context.
kubeconfig_write aws eks update-kubeconfig --region "$AWS_REGION_ARM" --name "$C_EKS_ARM" --alias "$C_EKS_ARM"
install_flux_operator "$C_EKS_ARM" arm     # ARM manifest, not the x86 one
register "$C_EKS_ARM" "$C_EKS_ARM"
