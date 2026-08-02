#!/usr/bin/env bash
# Delete every sched-* cluster, in parallel, and clean up the kubeconfig.
#
#   ./teardown-parallel.sh --dry-run     # list what would go
#   ./teardown-parallel.sh               # delete it
#
# The fleet is discovered from the providers rather than read from a list: a
# hardcoded list goes stale, and the cluster it forgets keeps billing. Anything
# named sched-* in the configured project and regions is in scope.
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

PREFIX="${PREFIX:-sched-}"
EKS_REGIONS="${EKS_REGIONS:-us-east-1 us-east-2}"
LOGDIR="${LOGDIR:-.}"

echo "== discovering clusters named ${PREFIX}*"
declare -a JOBS=()

for zone in $GCP_ZONE; do
  while read -r name; do
    [ -n "$name" ] || continue
    JOBS+=("gke|$name|$zone")
  done < <(gcloud container clusters list --project "$GCP_PROJECT" \
             --filter="name~^${PREFIX} AND location=${zone}" \
             --format='value(name)' 2>/dev/null)
done

for region in $EKS_REGIONS; do
  while read -r name; do
    [ -n "$name" ] || continue
    case "$name" in "${PREFIX}"*) JOBS+=("eks|$name|$region") ;; esac
  done < <(aws eks list-clusters --region "$region" \
             --query 'clusters[]' --output text 2>/dev/null | tr '\t' '\n')
done

if [ "${#JOBS[@]}" -eq 0 ]; then
  echo "nothing to delete"
else
  for j in "${JOBS[@]}"; do
    IFS='|' read -r cloud name loc <<< "$j"
    printf '  %-6s %-28s %s\n' "$cloud" "$name" "$loc"
  done
fi

if [ "$DRY" -eq 1 ]; then
  echo
  echo "dry run; nothing deleted"
  exit 0
fi

[ "${#JOBS[@]}" -eq 0 ] && exit 0

echo
echo "== deleting ${#JOBS[@]} cluster(s) in parallel; each logs to $LOGDIR/teardown-<name>.txt"
for j in "${JOBS[@]}"; do
  IFS='|' read -r cloud name loc <<< "$j"
  log="$LOGDIR/teardown-$name.txt"
  if [ "$cloud" = "gke" ]; then
    ( gcloud container clusters delete "$name" --project "$GCP_PROJECT" \
        --zone "$loc" --quiet ) > "$log" 2>&1 &
  else
    # --wait so the exit status reflects the stack actually going away; a
    # half-deleted CloudFormation stack blocks recreating the same name later.
    ( eksctl delete cluster --name "$name" --region "$loc" --wait ) > "$log" 2>&1 &
  fi
  echo "  started $name (pid $!)"
done

failed=0
for pid in $(jobs -p); do wait "$pid" || failed=$((failed + 1)); done
echo
[ "$failed" -eq 0 ] && echo "all delete commands returned 0" \
  || echo "$failed delete(s) returned non-zero; see $LOGDIR/teardown-*.txt" >&2

echo
echo "== removing contexts from $KUBECONFIG"
for j in "${JOBS[@]}"; do
  IFS='|' read -r cloud name loc <<< "$j"
  kubectl config delete-context "$name" >/dev/null 2>&1 && echo "  context $name" || true
  # eksctl names cluster/user entries by ARN, gcloud by gke_project_zone_name
  for entry in $(kubectl config view -o jsonpath='{range .clusters[*]}{.name}{"\n"}{end}' \
                   2>/dev/null | grep -F "$name" || true); do
    kubectl config delete-cluster "$entry" >/dev/null 2>&1 || true
    kubectl config delete-user "$entry" >/dev/null 2>&1 || true
  done
done

echo
echo "== verifying nothing is left"
left=0
for zone in $GCP_ZONE; do
  for name in $(gcloud container clusters list --project "$GCP_PROJECT" \
                  --filter="name~^${PREFIX} AND location=${zone}" \
                  --format='value(name)' 2>/dev/null); do
    echo "  STILL PRESENT (gke $zone): $name" >&2; left=$((left + 1))
  done
done
for region in $EKS_REGIONS; do
  for name in $(aws eks list-clusters --region "$region" --query 'clusters[]' \
                  --output text 2>/dev/null | tr '\t' '\n'); do
    case "$name" in "${PREFIX}"*)
      echo "  STILL PRESENT (eks $region): $name" >&2; left=$((left + 1)) ;;
    esac
  done
done

if [ "$left" -eq 0 ]; then
  echo "  clean: no ${PREFIX}* clusters remain"
  exit 0
fi
echo
echo "$left cluster(s) still billing. A failed eksctl delete usually leaves a" >&2
echo "CloudFormation stack; check the console or rerun this script." >&2
exit 1
