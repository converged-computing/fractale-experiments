#!/usr/bin/env bash
# Shape sweep. Comment out any line in TARGETS to skip it.
#
#   ./run.sh                      # run every uncommented target, both models
#   ./run.sh --only-missing       # skip (model,target) pairs already on disk
#   ./run.sh --dry-run            # print what would run
#   ./run.sh kripke               # only targets whose name matches
#
#   OUTROOT=shapes-20260813-0735 ./run.sh --only-missing   # fill gaps in a sweep
#   MODELS=us.anthropic.claude-sonnet-5 ./run.sh           # one model
#
# Output: $OUTROOT/<model-slug>/<host>/<org>/<repo>/<revision>[/<focus>]/shapes.json
#         $OUTROOT/<model-slug>/logs/<name>.log
# Analyse it afterwards with ./plot_shapes.py (extraction does no analysis).

set -u -o pipefail

# ---------------------------------------------------------------- what to run

# Sonnet first: cheaper and faster, so it shakes out bad URLs before Opus spends.
MODELS="${MODELS:-us.anthropic.claude-sonnet-5 us.anthropic.claude-opus-4-8}"

# name | repo | focus      (empty focus -> the agent enumerates variants itself)
TARGETS=(
  "lammps-reaxff|https://github.com/lammps/lammps|reaxff"
  "kripke|https://github.com/LLNL/Kripke|"
  "quicksilver|https://github.com/LLNL/Quicksilver|"
  "amg2023|https://github.com/LLNL/AMG2023|"
  "minife|https://github.com/Mantevo/miniFE|"
  "mixbench|https://github.com/ekondis/mixbench|"

  # AMG2023 ships only a driver and a Makefile -- the solver, and therefore all
  # of its communication, lives in hypre. Without this, AMG2023's thin result
  # looks like a tool failure rather than a property of the repo.
  "hypre|https://github.com/hypre-space/hypre|BoomerAMG algebraic multigrid solver"

  # Unverified sources. OSU and HPL are not published on GitHub by their
  # maintainers (OSU ships a tarball from mvapich.cse.ohio-state.edu, HPL from
  # netlib), so these are community mirrors that may lag upstream. AMG (CORAL-2)
  # and STREAM are also unconfirmed. Fix the URLs before trusting the results.
  "stream|https://github.com/jeffhammond/STREAM|"
  "amg-coral2|https://github.com/LLNL/AMG|"
  "hpl|https://github.com/icl-utk-edu/hpl|"

  # OSU: one repo, three benchmarks -> three focused runs, each its own trace.
  # These should come out visibly different (latency vs collective/reduction vs
  # bandwidth). If they don't, that is a finding about the tool.
  "osu-latency|https://github.com/jwu274/osu-micro-benchmarks|osu_latency point-to-point latency benchmark"
  "osu-allreduce|https://github.com/jwu274/osu-micro-benchmarks|osu_allreduce MPI_Allreduce collective benchmark"
  "osu-bw|https://github.com/jwu274/osu-micro-benchmarks|osu_bw bandwidth benchmark"
)

# ---------------------------------------------------------------- settings

BACKEND="${BACKEND:-aws}"
MAX_SOURCE_TOKENS="${MAX_SOURCE_TOKENS:-60000}"
MODEL_MAX_TOKENS="${MODEL_MAX_TOKENS:-16384}"
OUTROOT="${OUTROOT:-shapes-$(date +%Y%m%d-%H%M)}"
KEEP_IMAGES="${KEEP_IMAGES:-1}"   # reuse the pulled sandbox base across runs

# ---------------------------------------------------------------- args

ONLY_MISSING=""
DRY=""
FILTER=""
for arg in "$@"; do
  case "$arg" in
    --only-missing) ONLY_MISSING=1 ;;
    --dry-run)      DRY=1 ;;
    -h|--help)      sed -n '2,20p' "$0"; exit 0 ;;
    *)              FILTER="$arg" ;;
  esac
done

slug_of() { echo "$1" | tr './:' '---'; }

# Does this install support --yes? It only exists if the run-provenance patch was
# applied. Without it we have to pipe `yes` instead -- and then read
# PIPESTATUS[1], because `yes` takes SIGPIPE and under pipefail that would
# otherwise report a false failure for every successful run.
if artifact-secretary shape --help 2>/dev/null | grep -q -- '--yes'; then
  HAS_YES=1
else
  HAS_YES=""
  echo "note: this artifact-secretary has no --yes; falling back to piping 'yes'."
  echo "      (apply the run-provenance patch to get the in-process gate.)"
  echo
fi

# Does a report for this (model, repo, focus) already exist? Matched on the focus
# recorded inside the JSON, because the focus becomes a sanitised path segment
# and predicting that string is fragile.
have_report() {
  local model="$1" repo="$2" focus="$3"
  local dir="$OUTROOT/$(slug_of "$model")"
  [ -d "$dir" ] || return 1
  local hits
  hits=$(grep -rl -F "\"repo\": \"$repo\"" "$dir" --include='shapes.json' 2>/dev/null) || return 1
  local f
  for f in $hits; do
    grep -q -F "\"focus\": \"$focus\"" "$f" 2>/dev/null && return 0
  done
  return 1
}

# ---------------------------------------------------------------- run

echo "models:  $MODELS"
echo "output:  $OUTROOT/"
echo "budget:  $MAX_SOURCE_TOKENS source tokens, $MODEL_MAX_TOKENS output cap"
[ -n "$ONLY_MISSING" ] && echo "mode:    only missing runs"
[ -n "$FILTER" ] && echo "filter:  $FILTER"
echo

mkdir -p "$OUTROOT"
start=$(date +%s)
ran=0 skipped=0 failed=0

for model in $MODELS; do
  slug="$(slug_of "$model")"
  mdir="$OUTROOT/$slug"
  mkdir -p "$mdir/logs"
  echo "########## $model ##########"

  for entry in "${TARGETS[@]}"; do
    IFS='|' read -r name repo focus <<<"$entry"
    if [ -n "$FILTER" ] && [[ "$name" != *"$FILTER"* ]]; then
      continue
    fi
    if [ -n "$ONLY_MISSING" ] && have_report "$model" "$repo" "$focus"; then
      printf '  %-16s have it\n' "$name"
      skipped=$((skipped + 1))
      continue
    fi
    if [ -n "$DRY" ]; then
      printf '  %-16s would run%s\n' "$name" "${focus:+  (focus: ${focus%% *})}"
      continue
    fi

    args=(shape --backend "$BACKEND" --model "$model" --mode container
          --repos "$repo"
          --max-source-tokens "$MAX_SOURCE_TOKENS"
          --model-max-tokens "$MODEL_MAX_TOKENS"
          --out-dir "$mdir")
    [ -n "$focus" ] && args+=(--focus "$focus")
    [ "$KEEP_IMAGES" = "1" ] && args+=(--keep)

    printf '  %-16s ' "$name"
    t0=$(date +%s)
    if [ -n "$HAS_YES" ]; then
      artifact-secretary "${args[@]}" --yes >"$mdir/logs/$name.log" 2>&1
      rc=$?
    else
      yes | artifact-secretary "${args[@]}" >"$mdir/logs/$name.log" 2>&1
      rc=${PIPESTATUS[1]}   # the command's status, not `yes` dying on SIGPIPE
    fi
    secs=$(( $(date +%s) - t0 ))
    if [ "$rc" -ne 0 ]; then
      echo "FAILED (rc=$rc)  ${secs}s  see $mdir/logs/$name.log"
      failed=$((failed + 1))
    elif have_report "$model" "$repo" "$focus"; then
      echo "ok  ${secs}s"
      ran=$((ran + 1))
    else
      # exit 0 is not proof a report landed: a skipped clone exits cleanly
      echo "NO REPORT (rc=0, likely skipped)  ${secs}s  see $mdir/logs/$name.log"
      failed=$((failed + 1))
    fi
  done
  echo
done

if [ -n "$DRY" ]; then
  echo "(dry run: nothing executed)"
  exit 0
fi

echo "$ran ok, $failed failed, $skipped already present — $(( ($(date +%s) - start) / 60 )) min"
echo "output:  $OUTROOT/"
echo "gaps:    $0 --only-missing --dry-run   (with OUTROOT=$OUTROOT)"
echo "analyse: ./plot_shapes.py $OUTROOT --web web --fetch-source"