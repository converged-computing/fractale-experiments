#!/usr/bin/env bash
# Create the flux-secretary token secret in every cluster.
#
# The secretary runs INSIDE each MiniCluster, so the token has to exist in each
# cluster, not on the host. fluxq never sees it: it only records the secret NAME
# when the cluster is registered, and the operator mounts it.
#
# Export a credential first, then run this:
#
#   export AWS_BEARER_TOKEN_BEDROCK=...   # or ANTHROPIC_API_KEY
#   ./create-secret.sh                    # every cluster
#   ./create-secret.sh sched-gke-cpu      # just one
#
# Without a token the secretary still runs, using its deterministic ladder. That
# is the recommended mode for the experiment itself, so a second agent does not
# sit inside the measurement.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

SECRET_NAME="${SECRET_NAME:-flux-secretary-token}"
NAMESPACE="${NAMESPACE:-default}"
TOKEN="${FLUX_SECRETARY_TOKEN:-${AWS_BEARER_TOKEN_BEDROCK:-${ANTHROPIC_API_KEY:-}}}"

if [ -z "$TOKEN" ]; then
  echo "no credential found. Export one first:" >&2
  echo "  export AWS_BEARER_TOKEN_BEDROCK=...    # Bedrock" >&2
  echo "  export ANTHROPIC_API_KEY=sk-...        # Anthropic" >&2
  echo "  export FLUX_SECRETARY_TOKEN=...        # explicit override" >&2
  exit 1
fi

CONTEXTS=("$@")
if [ ${#CONTEXTS[@]} -eq 0 ]; then
  CONTEXTS=("${FLEET_CONTEXTS[@]}")
fi

failed=0
for ctx in "${CONTEXTS[@]}"; do
  echo "==> $ctx"
  # No silent skipping: a cluster without the token falls back to the
  # deterministic ladder while the others use the agent, and the two arms are
  # then not measuring the same thing.
  if ! kubectl config get-contexts -o name 2>/dev/null | grep -qx "$ctx"; then
    echo "    ERROR: not in $KUBECONFIG" >&2; failed=1; continue
  fi
  if ! kubectl --context "$ctx" version --request-timeout=20s >/dev/null 2>&1; then
    echo "    ERROR: unreachable" >&2; failed=1; continue
  fi
  # Delete first: create --dry-run | apply keeps an existing value if the key
  # differs, so a stale token can survive. This replaces it outright.
  kubectl --context "$ctx" delete secret "$SECRET_NAME" \
    --ignore-not-found --request-timeout=30s >/dev/null 2>&1 || true
  # The key is `token`: flux-secretary reads /etc/flux-secretary/token, and the
  # operator mounts each key in the secret as a file under that path.
  kubectl --context "$ctx" -n "$NAMESPACE" create secret generic "$SECRET_NAME" \
    --from-literal=token="$TOKEN" --dry-run=client -o yaml \
    | kubectl --context "$ctx" apply --request-timeout=30s -f - >/dev/null \
    && echo "    secret/$SECRET_NAME (recreated)" || { echo "    ERROR: apply failed" >&2; failed=1; }
done

echo
# Verify rather than trust the apply.
echo
echo "verifying:"
for ctx in "${CONTEXTS[@]}"; do
  got="$(kubectl --context "$ctx" get secret "$SECRET_NAME" \
           -o jsonpath='{.data.token}' --request-timeout=20s 2>/dev/null | head -c 12)"
  if [ -n "$got" ]; then
    echo "  $ctx ok"
  else
    echo "  $ctx MISSING or has no 'token' key" >&2; failed=1
  fi
done
[ "$failed" -eq 0 ] || { echo; echo "one or more clusters lack the secret" >&2; exit 1; }

echo
echo "The secretary exports this into the variable its backend reads, so a Bedrock"
echo "token becomes AWS_BEARER_TOKEN_BEDROCK inside the pod (--backend aws)."
echo
echo "Register clusters so fluxq mounts it (the token itself never reaches fluxq):"
echo "  fluxq cluster register --name <n> --manager flux-operator \\"
echo "    --config kubeconfig=/kube/config --config context=<n> \\"
echo "    --config secretary_secret=$SECRET_NAME --discover"
