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
# hpc7g.4xlarge is offered only in us-east-1a; us-east-2 has none.
export AWS_REGION_ARM="${AWS_REGION_ARM:-us-east-1}"
export GCP_PROJECT="${GCP_PROJECT:-llnl-flux}"
export GCP_REGION="${GCP_REGION:-us-central1}"
export GCP_ZONE="${GCP_ZONE:-us-central1-a}"

# Canonical cluster/context names (context == cluster name == fluxq cluster id).
export C_GKE_CPU=sched-gke-cpu
export C_GKE_GPU=sched-gke-gpu-nvidia
export C_EKS_ARM=sched-eks-arm-efa
export C_EKS_ARM_SMALL=sched-eks-arm-small
export C_EKS_GPU1=sched-eks-gpu-nvidia
export C_EKS_GPU4=sched-eks-gpu-nvidia-x4
export C_EKS_AMD=sched-eks-gpu-amd
export C_EKS_BIGMEM=sched-eks-cpu-efa-bigmem

# GKE stand-ins for the EKS clusters that could not be obtained: no EFA capacity
# in the available regions, and no ROCm driver in the EKS AMI for g4ad.
export C_GKE_ARM=sched-gke-arm
export C_GKE_BIGMEM=sched-gke-bigmem
export C_GKE_MID=sched-gke-mid
export C_GKE_GPU4=sched-gke-gpu-nvidia-x4

# The fleet, in ONE place. Every script defaults to this, so a cluster added or
# EVERY CLUSTER HAS THE SAME SHAPE: 8 physical cores per node, 3 nodes.
#
# Containment must never be the thing that decides placement. When it was, the
# result measured the fleet rather than the mechanism: amd64 + >=16GB resolved to
# two clusters, one of them took 76% of placements, and every performance number
# was really "that cluster is faster than the small one".
#
# Cores matter as much as nodes, because the agent sizes tasks to the cores it
# finds. A 2-core node got 4 tasks and a 16-core node got 32, so the two arms ran
# different jobs and the comparison was not a comparison. Uniform cores means the
# same launch everywhere and a difference that is attributable to the cluster.
#
# vCPU is not cores. x86 counts hardware threads, arm64 parts do not, so 8 real
# cores is 16 vCPU on Intel and AMD and 8 vCPU on Graviton and Ampere.
#
#   e2-highcpu-16    16 vCPU / 8 cores /  16 GiB   amd64
#   e2-standard-16   16 vCPU / 8 cores /  64 GiB   amd64
#   n2-highmem-16    16 vCPU / 8 cores / 128 GiB   amd64
#   t2a-standard-8    8 vCPU / 8 cores /  32 GiB   arm64  (Ampere Altra)
#   c7g.2xlarge       8 vCPU / 8 cores /  16 GiB   arm64  (Graviton3)
#   m7i.4xlarge      16 vCPU / 8 cores /  64 GiB   amd64
#
# The 192GB+ bucket is gone: memory scales with vCPU in every family, so that
# bucket forces a larger instance and breaks the core count. Three buckets remain
# and they are enough to discriminate.
export FLEET_CORES_PER_NODE=8
export FLEET_NODES=3

# dropped does not have to be chased through create-secret, make-portable-
# kubeconfig, register-all and teardown separately — which is how a run ends up
# against fewer clusters than intended.
#
# GCP has no EFA and the EKS AL2023 AMI ships no ROCm driver for g4ad, so the
# fabric and AMD clusters are not in here; see the README limitations.
FLEET_CONTEXTS=(
  "$C_GKE_CPU"
  "$C_GKE_ARM"
  "$C_GKE_BIGMEM"
  "$C_GKE_MID"
  # "$C_GKE_GPU"   # removed: flux cannot enumerate the device
  "$C_EKS_ARM_SMALL"
  # "$C_EKS_GPU1"  # removed: flux cannot enumerate the device
  "$C_EKS_BIGMEM"
)
export FLEET_CONTEXTS

# Fallbacks for the clusters that would not create. GCE capacity and quota are
# per zone AND per machine family, so the same request can fail all afternoon
# while a neighbouring zone or an AMD equivalent succeeds. These are what
# create-gke-bigmem.sh and create-gke-gpu.sh walk; override either to go straight
# to something you know has headroom.
#
#   GKE_BIGMEM_MACHINES="n2d-highmem-32" GKE_BIGMEM_ZONES="us-central1-b" \
#     PARALLEL=1 ./create-all.sh
#
# All 192GB+ and amd64, so the memory bucket does not change. n2d is AMD EPYC and
# draws on a different quota pool than n2, which is usually why one works.
# All 8 physical cores. n2d is AMD and draws on a different quota pool than n2,
# which is usually why one works when the other does not; both are 16 vCPU.
export GKE_BIGMEM_MACHINES="${GKE_BIGMEM_MACHINES:-n2-highmem-16 n2d-highmem-16 n1-highmem-16}"
export GKE_BIGMEM_ZONES="${GKE_BIGMEM_ZONES:-$GCP_ZONE us-central1-b us-central1-c us-central1-f}"

# machine:accelerator pairs, each landing in 16-64GB with one NVIDIA device. The
# experiment needs a node with an nvidia gpu in that bucket, not specifically an
# L4, and L4 is where the shortage usually is. T4 attaches to n1 and is the most
# widely available.
export GKE_GPU_PARTS="${GKE_GPU_PARTS:-g2-standard-8:nvidia-l4 n1-standard-8:nvidia-tesla-t4 n1-standard-8:nvidia-tesla-p4 n1-highmem-4:nvidia-tesla-t4 n1-standard-8:nvidia-tesla-v100}"
export GKE_GPU_ZONES="${GKE_GPU_ZONES:-$GCP_ZONE us-central1-b us-central1-c us-central1-f}"

FLUX_OPERATOR_X86=https://raw.githubusercontent.com/flux-framework/flux-operator/main/examples/dist/flux-operator.yaml
FLUX_OPERATOR_ARM=https://raw.githubusercontent.com/flux-framework/flux-operator/main/examples/dist/flux-operator-arm.yaml
export FLUX_OPERATOR_X86 FLUX_OPERATOR_ARM

# install_flux_operator <context> <x86|arm>
# eksctl_create <config.yaml> <cluster-name> <region>
# Create a cluster, then decide from AWS whether it worked.
#
# eksctl's exit code conflates two things: a real failure, and its own client
# side wait expiring ("exceeded max wait time for StackCreateComplete waiter")
# while CloudFormation is still building. A large GPU or EFA nodegroup routinely
# outlasts that wait, and with set -e the script dies before installing the
# operator, leaving a cluster that works but has no CRD.
#
# So on failure, ask AWS what the cluster is actually doing and keep going if it
# is ACTIVE, waiting for the nodegroup to settle.
eksctl_create() {
  local config="$1" name="$2" region="$3"
  if eksctl create cluster -f "$config"; then
    return 0
  fi
  echo "==> eksctl returned non-zero for $name; asking AWS what the state is" >&2
  local status
  status="$(aws eks describe-cluster --region "$region" --name "$name" \
              --query 'cluster.status' --output text 2>/dev/null || echo ABSENT)"
  if [ "$status" != "ACTIVE" ]; then
    echo "ERROR: $name is $status, not ACTIVE" >&2
    return 1
  fi
  echo "    control plane is ACTIVE; waiting for nodegroups" >&2
  local ng
  for ng in $(aws eks list-nodegroups --region "$region" --cluster-name "$name" \
                --query 'nodegroups[]' --output text 2>/dev/null); do
    local waited=0 ngs
    while :; do
      ngs="$(aws eks describe-nodegroup --region "$region" --cluster-name "$name" \
               --nodegroup-name "$ng" --query 'nodegroup.status' --output text 2>/dev/null)"
      case "$ngs" in
        ACTIVE) echo "    nodegroup $ng ACTIVE" >&2; break ;;
        CREATE_FAILED|DEGRADED)
          echo "ERROR: nodegroup $ng is $ngs" >&2
          aws eks describe-nodegroup --region "$region" --cluster-name "$name" \
            --nodegroup-name "$ng" --query 'nodegroup.health.issues' >&2
          return 1 ;;
      esac
      sleep 20
      waited=$((waited + 20))
      [ "$waited" -lt 1800 ] || { echo "ERROR: nodegroup $ng stuck at $ngs" >&2; return 1; }
    done
  done
  return 0
}

install_flux_operator() {
  local ctx="$1" arch="${2:-x86}" url="$FLUX_OPERATOR_X86"
  [ "$arch" = "arm" ] && url="$FLUX_OPERATOR_ARM"
  echo "==> installing flux operator ($arch) into $ctx"
  kubectl --context "$ctx" apply -f "$url"
  kubectl --context "$ctx" -n operator-system rollout status deploy/operator-controller-manager --timeout=5m || true
}

# kubeconfig_write <command...>
# Run a command that writes the kubeconfig, one at a time.
#
# Cluster creation is slow and overlaps happily, but `kubectl config`,
# `aws eks update-kubeconfig` and `gcloud get-credentials` each read-modify-write
# the same YAML with no locking of their own. Several at once interleave and lose
# entries, which surfaces later as a context that is missing or points at the
# wrong cluster.
kubeconfig_write() {
  # NOT ${KUBECONFIG}.lock: eksctl uses that name for its own locking, and a
  # leftover file there makes it refuse to write the context at all
  # ("unable to modify kubeconfig ...: kubeconfig.lock: file exists").
  local lock="${KUBECONFIG}.fleetq-lock"
  if command -v flock >/dev/null 2>&1; then
    ( flock 9 || exit 1; "$@" ) 9>"$lock"
  else
    # No flock (macOS): mkdir is atomic everywhere.
    local dir="${KUBECONFIG}.fleetq-lockdir" waited=0 rc=0
    until mkdir "$dir" 2>/dev/null; do
      sleep 1
      waited=$((waited + 1))
      [ "$waited" -lt 300 ] || { echo "kubeconfig lock stuck: $dir" >&2; return 1; }
    done
    "$@" || rc=$?
    rmdir "$dir"
    return $rc
  fi
}

# rename_context <current-name> <canonical-name>  (idempotent)
# gke_kubeconfig <cluster-name>
# Refresh the kubeconfig entry for a GKE cluster and give it the canonical
# context name. Always run this, not only at creation: a recreated cluster gets a
# new master IP, and a stale entry points at an address that no longer answers,
# which shows up as every kubectl call hanging.
#
# The stale cluster and user entries are removed too. Deleting only the context
# leaves the old cluster entry behind, and that is where the dead endpoint lives.
gke_kubeconfig() {
  local name="$1"
  local generated="gke_${GCP_PROJECT}_${GCP_ZONE}_${name}"

  # One lock for the whole sequence: get-credentials, the deletes and the rename
  # are a single read-modify-write as far as the file is concerned.
  _gke_write() {
    gcloud container clusters get-credentials "$name" \
      --project "$GCP_PROJECT" --zone "$GCP_ZONE" || return 1
    kubectl config delete-context "$name" >/dev/null 2>&1 || true
    kubectl config delete-cluster "$name" >/dev/null 2>&1 || true
    kubectl config delete-user "$name"    >/dev/null 2>&1 || true
    # get-credentials may already have written the canonical name; only rename
    # when the generated one is what exists.
    if kubectl config get-contexts -o name | grep -qx "$generated"; then
      kubectl config rename-context "$generated" "$name"
    fi
  }
  kubeconfig_write _gke_write || return 1

  # The endpoint in the kubeconfig must be the one gcloud reports. If they differ
  # the entry is stale and every call will hang instead of failing.
  local want got
  want="$(gcloud container clusters describe "$name" --project "$GCP_PROJECT" \
            --zone "$GCP_ZONE" --format='value(endpoint)')"
  got="$(kubectl config view --minify --context "$name" \
            -o jsonpath='{.clusters[0].cluster.server}' | sed 's|https://||')"
  if [ "$want" != "$got" ]; then
    echo "ERROR: kubeconfig for $name points at $got but the cluster is at $want" >&2
    return 1
  fi
  echo "==> $name kubeconfig refreshed ($got)"
}

rename_context() {
  local from="$1" to="$2"
  [ "$from" = "$to" ] && return 0
  kubectl config get-contexts -o name | grep -qx "$to" && kubectl config delete-context "$to" >/dev/null 2>&1
  kubeconfig_write kubectl config rename-context "$from" "$to"
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
  echo "==> $1 created; register later with ./register-all.sh"
}
