#!/usr/bin/env bash
# Register every cluster with the fluxq CONTAINER and discover its subsystems.
#
# This is a separate step (not part of the create scripts) because the container
# needs the portable kubeconfig, which can only be built once the clusters exist:
#
#   create clusters -> make-portable-kubeconfig.sh -> start container -> register-all.sh
#
# Registration runs via `docker exec` so the kubeconfig path is the one fluxq
# actually sees (/kube/config inside the container), not a host path.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

CONTAINER="${CONTAINER:-fluxq}"
# flux-operator so the transform emits a MiniCluster. A batch/v1 Job is a single
# pod, which cannot run a multi node job at all.
MANAGER="${MANAGER:-flux-operator}"
# Set only if the token secret exists in the clusters (see create-secret.sh).
# Empty means the secretary uses its deterministic ladder.
SECRETARY_SECRET="${SECRETARY_SECRET:-}"
KCFG_IN_CONTAINER="${KCFG_IN_CONTAINER:-/kube/config}"

CONTEXTS=("$@")
if [ ${#CONTEXTS[@]} -eq 0 ]; then
  CONTEXTS=("$C_GKE_CPU" "$C_GKE_ARM" "$C_GKE_BIGMEM" "$C_GKE_GPU" "$C_EKS_ARM_SMALL" "$C_EKS_GPU1" "$C_EKS_BIGMEM")
  # Remove GPU for now - none are working
  CONTEXTS=("$C_GKE_CPU" "$C_GKE_ARM" "$C_GKE_BIGMEM" "$C_EKS_ARM_SMALL" "$C_EKS_BIGMEM")
fi

docker ps --format '{{.Names}}' | grep -qx "$CONTAINER" || {
  echo "fluxq container '$CONTAINER' is not running — start it with fluxq-container/run.sh"; exit 1; }

for ctx in "${CONTEXTS[@]}"; do
  # only register what actually made it into the portable kubeconfig
  if ! docker exec "$CONTAINER" sh -c "grep -q 'name: $ctx' $KCFG_IN_CONTAINER" 2>/dev/null; then
    echo "skip $ctx (not in the mounted kubeconfig)"; continue
  fi
  echo "==> $ctx"
  docker exec "$CONTAINER" fluxq cluster register \
    --name "$ctx" --manager flux-operator \
    --config "kubeconfig=$KCFG_IN_CONTAINER" --config "context=$ctx" \
    ${SECRETARY_SECRET:+--config "secretary_secret=$SECRETARY_SECRET"} \
    --discover || echo "   FAILED: $ctx (continuing)"
done

echo; echo "registered fleet:"
curl -s "$FLUXQ/v1/clusters" | python3 -m json.tool 2>/dev/null | head -60
