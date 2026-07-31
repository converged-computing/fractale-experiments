#!/usr/bin/env bash
# Shared config for the subsystem-scheduling fleet. Source this first.
#
# KUBECONFIG STRATEGY: eksctl and gcloud both merge into one kubeconfig and each
# flips the *current context* to whatever it just created. We never rely on the
# current context — every cluster is given a deterministic context name here, and
# registered into fluxq with that explicit context. fluxq's k8s driver builds its
# client from (kubeconfig, context), so dispatch always reaches the right cluster
# no matter what "current" happens to be.
export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"

export FLUXQ="${FLUXQ:-http://localhost:8080}"

# GPU capacity is deepest in us-east-1; hpc7g (Graviton3E + EFA) is us-east-2.
# Clusters do NOT need to share a region — fluxq dispatches by context.
export AWS_REGION_GPU="${AWS_REGION_GPU:-us-east-1}"
export AWS_REGION_ARM="${AWS_REGION_ARM:-us-east-2}"
export GCP_PROJECT="${GCP_PROJECT:-llnl-flux}"
export GCP_REGION="${GCP_REGION:-us-central1}"
export GCP_ZONE="${GCP_ZONE:-us-central1-a}"

# Canonical cluster/context names (context == cluster name == fluxq cluster id).
export C_GKE_CPU=sched-gke-cpu
export C_GKE_GPU=sched-gke-gpu-nvidia
export C_EKS_ARM=sched-eks-arm-efa
export C_EKS_GPU1=sched-eks-gpu-nvidia
export C_EKS_GPU4=sched-eks-gpu-nvidia-x4
export C_EKS_AMD=sched-eks-gpu-amd
export C_EKS_BIGMEM=sched-eks-cpu-efa-bigmem

FLUX_OPERATOR_X86=https://raw.githubusercontent.com/flux-framework/flux-operator/main/examples/dist/flux-operator.yaml
FLUX_OPERATOR_ARM=https://raw.githubusercontent.com/flux-framework/flux-operator/main/examples/dist/flux-operator-arm.yaml
export FLUX_OPERATOR_X86 FLUX_OPERATOR_ARM

# install_flux_operator <context> <x86|arm>
install_flux_operator() {
  local ctx="$1" arch="${2:-x86}" url="$FLUX_OPERATOR_X86"
  [ "$arch" = "arm" ] && url="$FLUX_OPERATOR_ARM"
  echo "==> installing flux operator ($arch) into $ctx"
  kubectl --context "$ctx" apply -f "$url"
  kubectl --context "$ctx" -n operator-system rollout status deploy/operator-controller-manager --timeout=5m || true
}

# rename_context <current-name> <canonical-name>  (idempotent)
rename_context() {
  local from="$1" to="$2"
  [ "$from" = "$to" ] && return 0
  kubectl config get-contexts -o name | grep -qx "$to" && kubectl config delete-context "$to" >/dev/null 2>&1
  kubectl config rename-context "$from" "$to"
}

# GPU device plugin: some providers ship it, some don't. VERIFY, then install.
# check_gpu_plugin <context> <nvidia|amd>
check_gpu_plugin() {
  local ctx="$1" vendor="$2" key="nvidia.com/gpu"
  [ "$vendor" = "amd" ] && key="amd.com/gpu"
  echo "==> checking $ctx advertises $key"
  kubectl --context "$ctx" get nodes -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.allocatable.$key}{'\n'}{end}"
  echo "    (empty = plugin missing; install it, then re-check before registering)"
}

# register <name> <context>  — always by explicit context, never "current"
register() {
  local name="$1" ctx="$2"
  echo "==> registering $name with fluxq ($FLUXQ)"
  fluxq cluster register --server "$FLUXQ" --name "$name" --manager k8s-job \
    --config "kubeconfig=$KUBECONFIG" --config "context=$ctx" --discover
}
