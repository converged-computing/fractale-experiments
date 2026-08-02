#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl_create "$(dirname "$0")/eks-gpu-amd.yaml" "$C_EKS_AMD" $AWS_REGION_GPU
# `aws eks update-kubeconfig` is the reliable path (eksctl's own
# write-kubeconfig often does not stick); --alias names the context.
kubeconfig_write aws eks update-kubeconfig --region "$AWS_REGION_GPU" --name "$C_EKS_AMD" --alias "$C_EKS_AMD"
# EKS GPU AMIs usually ship the device plugin — VERIFY rather than assume.
check_gpu_plugin "$C_EKS_AMD" amd
install_flux_operator "$C_EKS_AMD" x86
register "$C_EKS_AMD" "$C_EKS_AMD"
