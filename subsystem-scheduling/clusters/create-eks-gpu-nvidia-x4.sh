#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl create cluster -f "$(dirname "$0")/eks-gpu-nvidia-x4.yaml"
eksctl utils write-kubeconfig --cluster "$C_EKS_GPU4" --region "$AWS_REGION_GPU"
rename_context "$(kubectl config current-context)" "$C_EKS_GPU4"
# EKS GPU AMIs usually ship the device plugin — VERIFY rather than assume.
check_gpu_plugin "$C_EKS_GPU4" nvidia
install_flux_operator "$C_EKS_GPU4" x86
register "$C_EKS_GPU4" "$C_EKS_GPU4"
