#!/usr/bin/env bash
# Make the operator schedulable on the arm clusters, on a cluster that already
# exists.
#
# create-gke-arm.sh does this at creation time. This is for a cluster that came up
# without it, which is what happened when the node pool re-applied the taint: GKE
# taints its arm64 (T2A) nodes kubernetes.io/arch=arm64:NoSchedule, our
# MiniClusters carry no tolerations, and the operator then sits Pending. Every job
# dispatched there waits until the timeout, which reads as a scheduling failure and
# is not one.
#
#   ./fix-arm-operator.sh                 # every arm context in the fleet
#   ./fix-arm-operator.sh sched-gke-arm   # just one
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

TARGETS=("$@")
if [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS=()
  for ctx in "${FLEET_CONTEXTS[@]}"; do
    arch="$(kubectl --context "$ctx" get nodes -o \
      jsonpath='{.items[0].status.nodeInfo.architecture}' \
      --request-timeout=20s 2>/dev/null)"
    [ "$arch" = "arm64" ] && TARGETS+=("$ctx")
  done
fi
if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "no arm64 clusters found in the fleet"
  exit 0
fi

failed=0
for ctx in "${TARGETS[@]}"; do
  echo "== $ctx"

  # The node pool re-applies the taint when nodes are replaced, so clear it at the
  # pool as well as on the nodes that exist now.
  gcloud container node-pools update default-pool --cluster "$ctx" \
    --project "$GCP_PROJECT" --zone "$GCP_ZONE" --node-taints="" \
    --quiet >/dev/null 2>&1 && echo "   pool taints cleared" \
    || echo "   pool update skipped (not GKE, or nothing to clear)"

  kubectl --context "$ctx" taint nodes --all \
    kubernetes.io/arch=arm64:NoSchedule- >/dev/null 2>&1 \
    && echo "   node taints removed" || echo "   no arch taint on the nodes"
  kubectl --context "$ctx" get nodes \
    -o custom-columns='NODE:.metadata.name,ARCH:.status.nodeInfo.architecture,TAINTS:.spec.taints'

  # apply alone will not replace an image on a deployment it considers reconciled,
  # so an x86 operator installed earlier has to be deleted first.
  image="$(kubectl --context "$ctx" -n operator-system get deploy \
    operator-controller-manager -o \
    jsonpath='{.spec.template.spec.containers[*].image}' 2>/dev/null || true)"
  case "$image" in
    *arm*) echo "   operator image already arm: $image" ;;
    "")    echo "   no operator yet; installing the arm manifest" ;;
    *)     echo "   operator image is $image, which is x86: replacing"
           kubectl --context "$ctx" -n operator-system delete deploy \
             operator-controller-manager --wait=true >/dev/null 2>&1 ;;
  esac
  kubectl --context "$ctx" apply -f "$FLUX_OPERATOR_ARM" >/dev/null 2>&1 \
    || { echo "   ERROR: could not apply the arm manifest" >&2; failed=$((failed+1)); continue; }

  if kubectl --context "$ctx" -n operator-system rollout status \
       deploy/operator-controller-manager --timeout=5m; then
    echo "   operator ready"
  else
    echo "   ERROR: operator still not ready" >&2
    kubectl --context "$ctx" -n operator-system get pods
    kubectl --context "$ctx" -n operator-system describe pod \
      -l control-plane=controller-manager | sed -n '/Events:/,$p'
    failed=$((failed + 1))
  fi
done

echo
[ "$failed" -eq 0 ] && { echo "all ${#TARGETS[@]} arm cluster(s) ready"; exit 0; }
echo "$failed arm cluster(s) still not ready" >&2
exit 1
