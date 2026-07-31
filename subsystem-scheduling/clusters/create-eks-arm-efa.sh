#!/usr/bin/env bash
# arm64 (Graviton3E) / no GPU / EFA / 128 GiB — uses the ARM flux-operator manifest
set -euo pipefail
source "$(dirname "$0")/env.sh"
eksctl create cluster -f "$(dirname "$0")/eks-arm-efa.yaml"
eksctl utils write-kubeconfig --cluster "$C_EKS_ARM" --region "$AWS_REGION_ARM"
rename_context "$(kubectl config current-context)" "$C_EKS_ARM"
install_flux_operator "$C_EKS_ARM" arm     # ARM manifest, not the x86 one
register "$C_EKS_ARM" "$C_EKS_ARM"
