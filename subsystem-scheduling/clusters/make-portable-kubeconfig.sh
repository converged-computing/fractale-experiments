#!/usr/bin/env bash
# Build a kubeconfig fluxq can use from INSIDE a container.
#
# WHY: GKE/EKS kubeconfigs do not contain credentials — they contain `exec`
# stanzas that shell out to gke-gcloud-auth-plugin / `aws eks get-token`. Those
# tools (and your cloud credentials) live on the HOST, so a bind-mounted
# ~/.kube/config would fail inside the fluxq container. This script runs on the
# host, where those tools work, and emits a self-contained kubeconfig with inline
# ServiceAccount tokens — no exec plugins, no cloud CLIs needed in the container.
#
#   ./make-portable-kubeconfig.sh            # all registered contexts
#   ./make-portable-kubeconfig.sh sched-gke-cpu
set -euo pipefail
cd "$(dirname "$0")"
source ./env.sh

OUT="${OUT:-$PWD/../fluxq-container/kubeconfig}"
DURATION="${DURATION:-24h}"      # re-run before this expires
NS="${NS:-default}"
SA="${SA:-fluxq}"

CONTEXTS=("$@")
if [ ${#CONTEXTS[@]} -eq 0 ]; then
  CONTEXTS=("$C_GKE_CPU" "$C_GKE_ARM" "$C_GKE_BIGMEM" "$C_EKS_ARM_SMALL" "$C_EKS_BIGMEM")
fi

TMP="$(mktemp)"; : > "$TMP"
cat > "$TMP" <<'HDR'
apiVersion: v1
kind: Config
clusters: []
users: []
contexts: []
HDR

for ctx in "${CONTEXTS[@]}"; do
  kubectl config get-contexts -o name 2>/dev/null | grep -qx "$ctx" || { echo "skip $ctx (not in kubeconfig)"; continue; }
  echo "==> $ctx"
  # Probe first: without this an unreachable cluster hangs the whole fleet
  # instead of erroring, because kubectl waits forever by default.
  if ! kubectl --context "$ctx" version --request-timeout=20s >/dev/null 2>&1; then
    echo "    UNREACHABLE, skipping (refresh its kubeconfig entry)" >&2
    continue
  fi
  cluster="$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.cluster}")"
  server="$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$cluster\")].cluster.server}")"
  ca="$(kubectl config view --raw -o jsonpath="{.clusters[?(@.name==\"$cluster\")].cluster.certificate-authority-data}")"

  kubectl --context "$ctx" -n "$NS" create serviceaccount "$SA" --dry-run=client -o yaml | kubectl --context "$ctx" apply --request-timeout=30s -f - >/dev/null
  kubectl --context "$ctx" create clusterrolebinding "$SA-admin" \
    --clusterrole=cluster-admin --serviceaccount="$NS:$SA" \
    --dry-run=client -o yaml | kubectl --context "$ctx" apply --request-timeout=30s -f - >/dev/null
  token="$(kubectl --context "$ctx" -n "$NS" create token "$SA" --duration="$DURATION" --request-timeout=30s)"

  KUBECONFIG="$TMP" kubectl config set-cluster "$ctx" --server="$server" >/dev/null
  if [ -n "$ca" ]; then
    python3 - "$TMP" "$ctx" "$ca" <<'PY'
import sys, yaml
path, name, ca = sys.argv[1], sys.argv[2], sys.argv[3]
d = yaml.safe_load(open(path))
for c in d["clusters"]:
    if c["name"] == name:
        c["cluster"]["certificate-authority-data"] = ca
        c["cluster"].pop("insecure-skip-tls-verify", None)
yaml.safe_dump(d, open(path, "w"))
PY
  fi
  KUBECONFIG="$TMP" kubectl config set-credentials "$ctx" --token="$token" >/dev/null
  KUBECONFIG="$TMP" kubectl config set-context "$ctx" --cluster="$ctx" --user="$ctx" >/dev/null
done

mkdir -p "$(dirname "$OUT")"; mv "$TMP" "$OUT"; chmod 600 "$OUT"
echo
echo "wrote $OUT (tokens valid $DURATION)"
echo "register clusters with the CONTAINER path:"
echo "  fluxq cluster register --name <n> --manager k8s-job \\"
echo "    --config kubeconfig=/kube/config --config context=<n> --discover"
