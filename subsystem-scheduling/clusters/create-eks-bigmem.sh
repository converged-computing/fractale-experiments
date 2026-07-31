#!/usr/bin/env bash
# amd64 / no GPU / EFA / 256 GiB  (top memory tier)
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl create cluster -f "$(dirname "$0")/eks-cpu-efa-bigmem.yaml"
eksctl utils write-kubeconfig --cluster "$C_EKS_BIGMEM" --region "$AWS_REGION_GPU"
rename_context "$(kubectl config current-context)" "$C_EKS_BIGMEM"
install_flux_operator "$C_EKS_BIGMEM" x86
register "$C_EKS_BIGMEM" "$C_EKS_BIGMEM"
