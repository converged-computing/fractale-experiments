#!/usr/bin/env bash
# Delete every cluster in the fleet, and the kubeconfig entries with them.
#
# Driven by FLEET_CONTEXTS rather than a hand-kept list. A cluster missing from a
# teardown list does not fail loudly: it keeps running, and keeps billing, until
# somebody notices. Use teardown-parallel.sh to catch anything named sched-* that
# is not in the fleet at all.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

# Which cloud a context belongs to, so the right tool is used. Anything not named
# here is tried against both, because guessing wrong is cheaper than skipping it.
gke_zone_of() {
  gcloud container clusters list --project "$GCP_PROJECT" \
    --filter="name=$1" --format='value(location)' 2>/dev/null | head -1
}

for ctx in "${FLEET_CONTEXTS[@]}"; do
  echo "== $ctx"
  zone="$(gke_zone_of "$ctx")"
  if [ -n "$zone" ]; then
    # The fallback scripts try several zones, so the cluster may not be in
    # $GCP_ZONE. Ask where it is rather than assuming.
    echo "   gke, in $zone"
    gcloud container clusters delete "$ctx" --project "$GCP_PROJECT" \
      --zone "$zone" --quiet --async || true
    continue
  fi
  for region in "$AWS_REGION_GPU" "$AWS_REGION_ARM" us-east-1; do
    [ -n "$region" ] || continue
    if aws eks describe-cluster --region "$region" --name "$ctx" >/dev/null 2>&1; then
      echo "   eks, in $region"
      eksctl delete cluster --region "$region" --name "$ctx" || true
      break
    fi
  done
done

echo
echo "== kubeconfig"
for ctx in "${FLEET_CONTEXTS[@]}"; do
  kubectl config delete-context "$ctx" >/dev/null 2>&1 && echo "   removed $ctx"
  kubectl config delete-cluster "$ctx" >/dev/null 2>&1
done

echo
echo "GKE deletes were started with --async. Confirm nothing is left before you"
echo "stop watching the bill:"
echo "  gcloud container clusters list --project $GCP_PROJECT"
echo "  aws eks list-clusters --region ${AWS_REGION_GPU:-us-east-1}"
