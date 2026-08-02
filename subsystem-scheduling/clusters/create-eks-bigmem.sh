#!/usr/bin/env bash
# amd64 / no GPU / EFA / 256 GiB  (top memory tier)
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl_create "$(dirname "$0")/eks-cpu-efa-bigmem.yaml" "$C_EKS_BIGMEM" $AWS_REGION_GPU
# `aws eks update-kubeconfig` is the reliable path (eksctl's own
# write-kubeconfig often does not stick); --alias names the context.
kubeconfig_write aws eks update-kubeconfig --region "$AWS_REGION_GPU" --name "$C_EKS_BIGMEM" --alias "$C_EKS_BIGMEM"
install_flux_operator "$C_EKS_BIGMEM" x86
register "$C_EKS_BIGMEM" "$C_EKS_BIGMEM"
