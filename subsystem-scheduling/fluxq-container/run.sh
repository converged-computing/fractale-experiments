#!/usr/bin/env bash
# Run fluxq (real Fluxion matcher) from the published image. Runs on the HOST,
# where docker lives; no cloud CLIs or credentials are needed in the container
# because the mounted kubeconfig carries static ServiceAccount tokens
# (see clusters/make-portable-kubeconfig.sh).
#
#   IMAGE=ghcr.io/converged-computing/fluxq:latest ./run.sh
set -euo pipefail
cd "$(dirname "$0")"

IMAGE="${IMAGE:-ghcr.io/converged-computing/fluxq:latest}"
PORT="${PORT:-8080}"
KUBECONFIG_FILE="${KUBECONFIG_FILE:-$PWD/kubeconfig}"

[ -f "$KUBECONFIG_FILE" ] || { echo "missing $KUBECONFIG_FILE — run ../clusters/make-portable-kubeconfig.sh first"; exit 1; }
grep -q "exec:" "$KUBECONFIG_FILE" && { echo "ERROR: $KUBECONFIG_FILE still has exec auth (needs gcloud/aws in the container)"; exit 1; }

mkdir -p data
docker pull "$IMAGE"
docker rm -f fluxq >/dev/null 2>&1 || true
docker run -d --name fluxq \
  -p "${PORT}:8080" \
  -v "$KUBECONFIG_FILE:/kube/config:ro" \
  -v "$PWD/data:/data" \
  "$IMAGE"

sleep 4
echo "==> fluxq on http://localhost:${PORT}"
docker logs fluxq 2>&1 | tail -8
echo
if docker logs fluxq 2>&1 | grep -qi "DEV DOUBLE"; then
  echo "WARNING: this image was built without -tags fluxion (stand-in matcher, not Fluxion)"
else
  echo "ok: real Fluxion matcher"
fi
echo
echo "register clusters with the CONTAINER kubeconfig path:"
echo "  fluxq cluster register --server http://localhost:${PORT} --name <n> --manager k8s-job \\"
echo "    --config kubeconfig=/kube/config --config context=<n> --discover"
