#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl_create "$(dirname "$0")/eks-gpu-nvidia.yaml" "$C_EKS_GPU1" $AWS_REGION_GPU
# `aws eks update-kubeconfig` is the reliable path (eksctl's own
# write-kubeconfig often does not stick); --alias names the context.
kubeconfig_write aws eks update-kubeconfig --region "$AWS_REGION_GPU" --name "$C_EKS_GPU1" --alias "$C_EKS_GPU1"
# EKS GPU AMIs usually ship the device plugin — VERIFY rather than assume.
check_gpu_plugin "$C_EKS_GPU1" nvidia
install_flux_operator "$C_EKS_GPU1" x86
register "$C_EKS_GPU1" "$C_EKS_GPU1"
