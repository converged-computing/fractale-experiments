#!/usr/bin/env bash
# Can fluxq actually create a MiniCluster on each cluster?
#
# Registration and matching only need to READ a cluster: the subsystem graphs are
# discovered once and then live inside fluxq, so a cluster stays feasible forever
# after. Dispatch needs to WRITE. Those are different permissions and different
# credentials, and the first can pass while the second fails.
#
# When it does, the cluster is invisibly broken: registered, feasible, top of the
# ranking, and it takes no jobs at all. That cost a ten-iteration run — two of six
# clusters took 0 of 191 placements and nothing reported an error.
#
# It uses THE KUBECONFIG FLUXQ USES, not your own. That distinction is the whole
# point: your ~/.kube/config has live gcloud and aws credentials, and fluxq has a
# portable one with baked tokens. A check run with your credentials passes while
# fluxq cannot reach the cluster at all, which is exactly the failure it is meant
# to catch.
#
# This is a server-side dry run. It creates nothing and costs nothing.
#
#   ./can-dispatch.sh                 # every cluster in the fleet
#   ./can-dispatch.sh sched-gke-mid   # one
#   KUBECONFIG_HOST=1 ./can-dispatch.sh   # your credentials instead, to compare
set -uo pipefail
cd "$(dirname "$0")"
source ./env.sh

# The file mounted into the container. Same tokens, same servers, same contexts.
KCFG="${KCFG:-../fluxq-container/kubeconfig}"
if [ "${KUBECONFIG_HOST:-}" = "1" ]; then
  KCFG=""
  echo "using YOUR credentials, which is not what fluxq uses" >&2
elif [ ! -f "$KCFG" ]; then
  echo "no portable kubeconfig at $KCFG" >&2
  echo "build it with make-portable-kubeconfig.sh, or set KCFG=path" >&2
  exit 2
else
  echo "using fluxq's kubeconfig: $KCFG"
fi

# every kubectl below goes through it
k() {
  if [ -n "$KCFG" ]; then kubectl --kubeconfig "$KCFG" "$@"; else kubectl "$@"; fi
}

TARGETS=("$@")
[ ${#TARGETS[@]} -eq 0 ] && TARGETS=("${FLEET_CONTEXTS[@]}")

# A minimal MiniCluster. Never created: --dry-run=server asks the API server to
# validate and admit it, then discards it, which exercises the CRD, the namespace
# and the caller's write permission in one request.
probe() {
  cat <<YAML
apiVersion: flux-framework.org/v1alpha2
kind: MiniCluster
metadata:
  name: dispatch-probe
  namespace: default
spec:
  size: 1
  containers:
    - image: busybox
      command: "true"
YAML
}

bad=0
for ctx in "${TARGETS[@]}"; do
  printf '  %-28s ' "$ctx"

  # 1. reachable at all
  if ! k --context "$ctx" version --request-timeout=15s >/dev/null 2>&1; then
    echo "UNREACHABLE with fluxq's credentials"; bad=$((bad+1)); continue
  fi

  # 2. the CRD is installed, or there is nothing to create
  if [ "$(k --context "$ctx" get crd 2>/dev/null | grep -c minicluster)" -eq 0 ]; then
    echo "NO MiniCluster CRD (the flux-operator is not installed)"; bad=$((bad+1)); continue
  fi

  # 3. the operator is actually running, or the object is admitted and ignored
  running="$(k --context "$ctx" -n operator-system get pods --no-headers \
    --request-timeout=15s 2>/dev/null | grep -c Running)"
  if [ "$running" -eq 0 ]; then
    echo "OPERATOR NOT RUNNING"; bad=$((bad+1)); continue
  fi

  # 4. and we may create one. This is the check the other three cannot replace.
  err="$(probe | k --context "$ctx" apply --dry-run=server -f - 2>&1)"
  if [ $? -ne 0 ]; then
    echo "CANNOT CREATE"
    echo "$err" | sed 's/^/       /' | head -3
    bad=$((bad+1)); continue
  fi

  echo "ok (crd, operator running, create permitted)"
done

echo
if [ "$bad" -ne 0 ]; then
  echo "$bad cluster(s) cannot be dispatched to." >&2
  echo "They will still register and still appear feasible, and they will take no" >&2
  echo "jobs. Rebuild the portable kubeconfig and re-register before running:" >&2
  echo "  bash ./make-portable-kubeconfig.sh && docker restart fluxq" >&2
  echo "  SECRETARY_SECRET=... ./register-all.sh" >&2
  exit 1
fi
echo "all ${#TARGETS[@]} cluster(s) can be dispatched to"
