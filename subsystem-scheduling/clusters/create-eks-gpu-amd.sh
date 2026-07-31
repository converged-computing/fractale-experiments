#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl create cluster -f "$(dirname "$0")/eks-gpu-amd.yaml"
eksctl utils write-kubeconfig --cluster "$C_EKS_AMD" --region "$AWS_REGION_GPU"
rename_context "$(kubectl config current-context)" "$C_EKS_AMD"
# EKS GPU AMIs usually ship the device plugin — VERIFY rather than assume.
check_gpu_plugin "$C_EKS_AMD" amd
install_flux_operator "$C_EKS_AMD" x86
register "$C_EKS_AMD" "$C_EKS_AMD"
