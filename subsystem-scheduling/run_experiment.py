#!/usr/bin/env python3
"""Run every authored jobspec TWICE and record the paired difference.

    base       the jobspec with `requires` REMOVED   (no descriptive metadata)
    subsystem  the jobspec exactly as authored       (descriptive metadata)

Container, node count and command are identical; the only variable is whether the
scheduler could match on architecture / network / gpu / memory. The per-jobspec
difference is the measurement.

Why strip `requires` instead of unregistering the subsystems: a `requires` naming
a subsystem the cluster has not registered is NOT ignored, it is unsatisfiable
(pkg/matcher: `g := cg.Subsystems[sub]; if g == nil { return false }`).
Unregistering makes every job match nothing. Removing the requires is the faithful
"scheduler has no descriptive metadata" condition: placement falls back to
containment alone.

    python run_experiment.py                        # placement only (free)
    python run_experiment.py --submit --timeout 900 # dispatch, monitor, save logs

Outputs
    results.json            every record + summary
    runs/<app>/<cond>.log            fluxq's job log, when one exists
    runs/<app>/<cond>.broker.log     rank 0's terminal output (FLUXSEC + the app)
    runs/<app>/<cond>.json           the final job record
    runs/<app>/<cond>.manifest.yaml  the dispatched artifact (MiniCluster/Job)
"""

import argparse
import copy
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))

# Terminal job states (pkg/queue); anything else is still in flight.
DONE = {"COMPLETED", "FAILED"}

# Talk to fluxq directly: a proxy in the environment (common on lab machines)
# swallows localhost requests and hangs instead of failing fast.
_OPENER = urllib.request.build_opener(urllib.request.ProxyHandler({}))


def _req(url, payload=None, timeout=30, raw=False):
    if payload is None:
        req = urllib.request.Request(url)
    else:
        req = urllib.request.Request(
            url, data=json.dumps(payload).encode(), method="POST",
            headers={"Content-Type": "application/json"})
    with _OPENER.open(req, timeout=timeout) as r:
        body = r.read().decode(errors="replace")
    if raw:
        return body
    return json.loads(body) if body.strip() else None


def field(d, *names, default=None):
    """Job records use Go field names (State, ClusterID). Be forgiving."""
    if not isinstance(d, dict):
        return default
    for n in names:
        for k in (n, n.lower(), n.upper()):
            if k in d:
                return d[k]
    return default


def load_jobspecs(root):
    out = {}
    for app in sorted(os.listdir(root)):
        path = os.path.join(root, app, "jobspec.json")
        if os.path.isfile(path):
            with open(path) as f:
                out[app] = json.load(f)
    return out


def strip_requires(js):
    base = copy.deepcopy(js)
    base.pop("requires", None)
    return base


def satisfy(fluxq, js):
    """Ranked feasible clusters. Allocates nothing, costs nothing."""
    try:
        cands = _req(f"{fluxq}/v1/jobs/satisfy", js) or []
    except urllib.error.HTTPError as e:
        return {"error": f"HTTP {e.code}: {e.read().decode()[:200]}", "feasible": 0, "cluster": None}
    except Exception as e:  # noqa: BLE001
        return {"error": str(e), "feasible": 0, "cluster": None}
    if not cands:
        return {"feasible": 0, "cluster": None, "matched": [], "score": None}
    top = cands[0]
    return {"feasible": len(cands), "cluster": top.get("cluster"),
            "matched": top.get("matched", []), "score": top.get("score"),
            "free_now": top.get("free_now"),
            "candidates": [c.get("cluster") for c in cands]}


def save_log(fluxq, jid, path):
    """Persist the job log. An absent log is normal for a job that never started —
    that is itself a result, so record the reason instead of failing."""
    try:
        text = _req(f"{fluxq}/v1/jobs/{jid}/log", raw=True)
    except urllib.error.HTTPError as e:
        text = f"(no log: HTTP {e.code})"
    except Exception as e:  # noqa: BLE001
        text = f"(no log: {e})"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(text or "")
    return len((text or "").strip())


def save_broker_log(cluster, name, path):
    """Persist the lead broker's terminal output: pod index 0 of the MiniCluster.

    fluxq's job log is the object's status, not what the application printed.
    Rank 0 is where flux-secretary writes its transcript and where the workload's
    own stdout lands, so without this a run leaves no record of what happened
    inside it. Captured before cleanup, since deleting the object takes the pods.
    """
    text = ""
    if cluster and name:
        pods = subprocess.run(
            ["kubectl", "--context", cluster, "get", "pods",
             "-l", f"job-name={name}", "-o",
             "jsonpath={range .items[*]}{.metadata.name}{\"\\n\"}{end}"],
            capture_output=True, text=True)
        # <minicluster>-<index>-<hash>: index 0 is the broker
        rank0 = next(
            (p for p in pods.stdout.split() if p.startswith(f"{name}-0-")), "")
        if rank0:
            r = subprocess.run(
                ["kubectl", "--context", cluster, "logs", rank0,
                 "--all-containers", "--tail=-1"],
                capture_output=True, text=True)
            text = r.stdout or f"(no output: {r.stderr.strip()})"
        else:
            text = f"(no pod {name}-0-* in {cluster}; it may already be gone)"
    else:
        text = "(no pod: the job never reached a cluster)"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(text if text.endswith("\n") else text + "\n")
    return len(text.strip())


# Container failures Kubernetes retries forever, so the object never reaches a
# terminal state and fluxq keeps reporting RUNNING. Waiting the full timeout for
# these costs the whole fleet's hourly rate for nothing, and the diagnosis is
# already certain the first time the container dies.
WEDGED = {
    "CrashLoopBackOff": "the container keeps dying on start",
    "ImagePullBackOff": "the image cannot be pulled",
    "ErrImagePull": "the image cannot be pulled",
    "CreateContainerConfigError": "the pod config is wrong (missing secret?)",
    "InvalidImageName": "the image reference is malformed",
}


def pod_wedged(cluster, name):
    """Why a job's pods cannot start, or "" if they look fine.

    `exec format error` is the one worth catching fastest: an amd64 image on
    arm64 dies instantly and is retried forever, so the base arm of every
    cross-architecture job burns its entire timeout at full fleet cost. The
    verdict is available from the first restart.
    """
    if not cluster or not name:
        return ""
    out = subprocess.run(
        ["kubectl", "--context", cluster, "get", "pods",
         "-l", f"job-name={name}", "-o", "json", "--request-timeout=20s"],
        capture_output=True, text=True)
    if out.returncode != 0 or not out.stdout.strip():
        return ""
    try:
        pods = json.loads(out.stdout).get("items", [])
    except json.JSONDecodeError:
        return ""

    # An arch mismatch is the most specific verdict available, so look for it
    # first: CrashLoopBackOff would otherwise mask it with a generic message.
    for pod in pods:
        st = pod.get("status") or {}
        for cs in (st.get("containerStatuses") or []) + (st.get("initContainerStatuses") or []):
            term = (cs.get("lastState") or {}).get("terminated") or {}
            if "exec format error" in (term.get("message") or ""):
                return "exec format error: the image is built for another architecture"

    for pod in pods:
        st = pod.get("status") or {}
        for cs in (st.get("containerStatuses") or []) + (st.get("initContainerStatuses") or []):
            waiting = (cs.get("state") or {}).get("waiting") or {}
            reason = waiting.get("reason", "")
            if reason in WEDGED:
                # only give up once it has actually retried: a single restart can
                # be a transient image pull
                if reason != "CrashLoopBackOff" or (cs.get("restartCount") or 0) >= 2:
                    detail = (waiting.get("message") or "").strip()[:120]
                    return f"{reason}: {WEDGED[reason]}" + (f" ({detail})" if detail else "")
    # the message often only appears in the log, not the status
    if pods:
        first = pods[0].get("metadata", {}).get("name", "")
        if first:
            lg = subprocess.run(
                ["kubectl", "--context", cluster, "logs", first,
                 "--all-containers", "--tail=20", "--request-timeout=20s"],
                capture_output=True, text=True)
            if "exec format error" in (lg.stdout + lg.stderr):
                return "exec format error: the image is built for another architecture"
    return ""


def secretary_result(path):
    """The workload's own outcome, read from the broker log.

    The MiniCluster object reaching a terminal state does not mean the workload
    ran: in one pass 18 of 28 objects fluxq reported as COMPLETED had an
    application that never started. flux-secretary prints a final record whose
    status is the job's, so that is the outcome to believe.

    Returns (status, runtime_s, attempts, reason) with status one of:
      ok            the workload ran and exited 0
      failed        it ran or was attempted and did not succeed
      never-started the secretary never printed anything
      no-log        there is no broker log to read
    """
    try:
        text = open(path, errors="replace").read()
    except OSError:
        return "no-log", None, 0, ""
    if "FLUXSEC" not in text:
        return "never-started", None, 0, ""

    tx = None
    for line in reversed(text.splitlines()):
        if line.startswith("FLUXSEC json "):
            try:
                tx = json.loads(line[len("FLUXSEC json "):])
            except json.JSONDecodeError:
                tx = None
            break
    if tx is None:
        # started but died before the summary; the attempt lines still say so
        return "failed", None, text.count("FLUXSEC attempt "), "no result record"

    attempts = tx.get("attempts") or []
    ran = next((a for a in attempts if a.get("status") == "ok"), None)
    status = "ok" if tx.get("status") == "ok" and ran else "failed"
    return (
        status,
        ran.get("runtime_s") if ran else None,
        len(attempts),
        str(tx.get("reason") or "")[:300],
    )


def _tick(msg):
    """Progress on one line, so a long poll does not look like a hang."""
    sys.stdout.write("\r" + msg.ljust(78))
    sys.stdout.flush()


def cleanup(cluster, name, kinds=("minicluster", "job")):
    """Delete the dispatched object so runs do not accumulate.

    Two conditions x 18 apps x re-runs share object names, so leftovers both
    litter the cluster and collide with the next create. fluxq exposes no delete
    endpoint, so we remove it directly in the cluster's own kube-context.
    """
    if not cluster:
        return []
    removed = []
    for kind in kinds:
        r = subprocess.run(
            ["kubectl", "--context", cluster, "delete", kind, name,
             "--ignore-not-found", "--wait=false"],
            capture_output=True, text=True)
        if r.returncode == 0 and r.stdout.strip():
            removed.append(f"{kind}/{name}")
    return removed


def run(fluxq, js, outdir, cond, timeout, poll):
    """Submit, monitor to a terminal state, save the log and the final record.

    Every outcome is recorded, never raised:
      submit_error  the server refused the job
      unmatched     never left SUBMITTED — nothing satisfied it
      timeout       still in flight when the wall clock expired
      failed        reached FAILED (wrong arch, OOM, bad command, ...)
      completed     reached COMPLETED
    """
    started = time.time()
    try:
        resp = _req(f"{fluxq}/v1/jobs/submit", js)
    except urllib.error.HTTPError as e:
        return {"outcome": "submit_error", "ran": False, "seconds": 0,
                "error": f"HTTP {e.code}: {e.read().decode()[:300]}"}
    except Exception as e:  # noqa: BLE001
        return {"outcome": "submit_error", "ran": False, "seconds": 0, "error": str(e)}

    jid = (resp or {}).get("id")
    if not jid:
        return {"outcome": "submit_error", "ran": False, "seconds": 0,
                "error": f"no id in {resp!r}"}

    rec, state, seen, wedged = {}, "UNKNOWN", None, ""
    while time.time() - started < timeout:
        try:
            rec = _req(f"{fluxq}/v1/jobs/{jid}") or {}
            state = str(field(rec, "State", default="UNKNOWN")).upper()
        except Exception:  # noqa: BLE001 - transient; keep polling
            time.sleep(poll)
            continue
        secs = int(time.time() - started)
        where = field(rec, "ClusterID") or "-"
        note = (field(rec, "Note") or "")[:28]
        _tick(f"    {cond}: {state} on {where} {secs}s/{timeout}s"
              + (f"  {note}" if note else ""))
        if state != seen:
            seen = state
        if state in DONE:
            break

        # A pod that cannot start is retried forever, so the object never becomes
        # terminal. Stop as soon as the reason is certain rather than paying for
        # the rest of the timeout.
        if secs >= 30 and secs % 30 < poll:
            handle = str(field(rec, "RemoteHandle", default="") or "")
            if "/" in handle:
                handle = handle.rsplit("/", 1)[-1]
            if not handle:
                handle = (js.get("attributes", {}).get("system", {})
                            .get("job", {}).get("name", ""))
            why = pod_wedged(field(rec, "ClusterID"), handle)
            if why:
                wedged = why
                break
        time.sleep(poll)
    _tick("")
    sys.stdout.write("\r")

    elapsed = round(time.time() - started, 1)
    timed_out = state not in DONE
    if not timed_out:
        outcome = "completed" if state == "COMPLETED" else "failed"
    elif wedged:
        # a certain diagnosis, reached in seconds instead of the full timeout
        outcome = "pod_wedged"
    elif state == "SUBMITTED":
        outcome = "unmatched"      # never matched a cluster at all
    else:
        outcome = "timeout"        # matched/dispatched but did not finish in time

    base = os.path.join(outdir, cond)
    log_bytes = save_log(fluxq, jid, base + ".log")

    # The dispatched artifact (MiniCluster / Job manifest) is provenance: it is
    # what actually ran, including the size/tasks the transform derived. Write it
    # beside the log rather than leaving it buried in the job record.
    artifact = str(field(rec, "Artifact", default="") or "")
    if artifact.strip():
        with open(base + ".manifest.yaml", "w") as f:
            f.write(artifact if artifact.endswith("\n") else artifact + "\n")
    with open(base + ".json", "w") as f:
        json.dump(rec, f, indent=2, default=str)

    # logs and the record are already persisted, so it is safe to remove the
    # object now; leaving it would collide with the next condition/run.
    # RemoteHandle is the native object id at the target (k8s object name);
    # fall back to the jobspec's job name, which is what the transform uses.
    handle = str(field(rec, "RemoteHandle", default="") or "")
    if "/" in handle:
        handle = handle.rsplit("/", 1)[-1]
    if not handle:
        handle = (js.get("attributes", {}).get("system", {})
                    .get("job", {}).get("name", ""))
    broker_bytes = save_broker_log(
        field(rec, "ClusterID"), handle, base + ".broker.log")

    # What happened INSIDE the container. fluxq reports the object's state, which
    # is terminal whether or not the workload ran, so the outcome is corrected
    # here and the runtime comes from the job eventlog rather than our poll.
    inner, runtime_s, attempts, reason = secretary_result(base + ".broker.log")
    if outcome == "completed" and inner != "ok":
        outcome = {
            "never-started": "never_started",
            "no-log": "no_broker_log",
        }.get(inner, "app_failed")

    gone = cleanup(field(rec, "ClusterID"), handle or None)

    return {"outcome": outcome, "ran": inner == "ok", "id": jid,
            # the workload's own view, which is the one to report
            "app_status": inner, "runtime_s": runtime_s,
            "wedged": wedged,
            "attempts": attempts, "app_reason": reason,
            "cleaned": gone,
            "state": state, "seconds": elapsed, "timed_out": timed_out,
            "cluster": field(rec, "ClusterID"),
            "note": field(rec, "Note"),               # driver's reason for failure
            "suggestion": field(rec, "Suggestion"),   # fluxq's reconfiguration hint
            "reschedules": field(rec, "Reschedules", default=0),
            "log_bytes": log_bytes, "log": base + ".log",
            "broker_bytes": broker_bytes, "broker_log": base + ".broker.log",
            "manifest": (base + ".manifest.yaml") if artifact.strip() else None}


def main(argv=None):
    p = argparse.ArgumentParser(description="Paired base vs subsystem experiment.")
    p.add_argument("--fluxq", default=os.environ.get("FLUXQ", "http://localhost:8080"))
    p.add_argument("--jobspecs", default=os.path.join(HERE, "jobspecs"))
    p.add_argument("--out", default=os.path.join(HERE, "results.json"))
    p.add_argument("--runs", default=os.path.join(HERE, "runs"), help="logs + job records")
    p.add_argument("--submit", action="store_true",
                   help="dispatch and monitor (default: placement only, free)")
    p.add_argument("--timeout", type=int, default=900, help="per-run wall clock, seconds")
    p.add_argument("--poll", type=int, default=10)
    p.add_argument("--only", default="", help="comma-separated app names")
    args = p.parse_args(argv)

    jobs = load_jobspecs(args.jobspecs)
    if args.only:
        keep = {s.strip() for s in args.only.split(",")}
        jobs = {k: v for k, v in jobs.items() if k in keep}
    if not jobs:
        print(f"no jobspecs under {args.jobspecs}", file=sys.stderr)
        return 1

    results = []
    for app, js in jobs.items():
        rec = {"app": app, "requires": sorted(js.get("requires") or {})}
        try:
            rec["nodes"] = js["resources"][0].get("count")
        except (KeyError, IndexError):
            rec["nodes"] = None

        if args.submit:
            print(f"{app} ...")
        for cond, spec in (("base", strip_requires(js)), ("subsystem", js)):
            entry = {"placement": satisfy(args.fluxq, spec)}
            if args.submit:
                if not entry["placement"].get("feasible"):
                    # Nowhere to place it is a RESULT. Record it; don't burn the
                    # wall clock submitting a job that cannot be scheduled.
                    entry["run"] = {"outcome": "unschedulable", "ran": False,
                                    "seconds": 0,
                                    "note": "no feasible cluster at satisfy"}
                else:
                    entry["run"] = run(args.fluxq, spec,
                                       os.path.join(args.runs, app), cond,
                                       args.timeout, args.poll)
                    r = entry["run"]
                    print(f"    {cond}: {r['outcome']} in {r.get('seconds')}s"
                          f" on {r.get('cluster') or '-'}"
                          f" log={r.get('log_bytes', 0)}B"
                          + (f"  cleaned={','.join(r['cleaned'])}" if r.get("cleaned") else "")
                          + (f"  note={r['note']}" if r.get("note") else ""))
            rec[cond] = entry

        b, s = rec["base"]["placement"], rec["subsystem"]["placement"]
        d = {"same_cluster": b.get("cluster") == s.get("cluster"),
             "base_cluster": b.get("cluster"), "subsystem_cluster": s.get("cluster"),
             "base_feasible": b.get("feasible"),
             "subsystem_feasible": s.get("feasible")}
        if args.submit:
            br, sr = rec["base"]["run"], rec["subsystem"]["run"]
            d.update({"base_outcome": br["outcome"], "subsystem_outcome": sr["outcome"],
                      "base_ran": br["ran"], "subsystem_ran": sr["ran"],
                      "base_seconds": br.get("seconds"),
                      "subsystem_seconds": sr.get("seconds"),
                      # in-container runtime from the job eventlog, not our poll
                      "base_runtime_s": br.get("runtime_s"),
                      "subsystem_runtime_s": sr.get("runtime_s")})
            # WHERE IT RAN beats where satisfy predicted it would. The prediction
            # is made before dispatch and free capacity moves in between, so the
            # two disagree; comparing predictions would count prediction
            # disagreement as a placement difference. Both are kept so the
            # divergence stays visible.
            d["predicted_base_cluster"] = d["base_cluster"]
            d["predicted_subsystem_cluster"] = d["subsystem_cluster"]
            if br.get("cluster"):
                d["base_cluster"] = br["cluster"]
            if sr.get("cluster"):
                d["subsystem_cluster"] = sr["cluster"]
            d["same_cluster"] = d["base_cluster"] == d["subsystem_cluster"]
            d["prediction_held"] = (
                d["predicted_base_cluster"] == d["base_cluster"]
                and d["predicted_subsystem_cluster"] == d["subsystem_cluster"]
            )
            if br["ran"] and sr["ran"]:
                d["seconds_delta"] = round(br["seconds"] - sr["seconds"], 1)
        rec["diff"] = d
        results.append(rec)

        line = (f"{app:26} base={str(d['base_cluster']):24} "
                f"sub={str(d['subsystem_cluster']):24} "
                f"{'same' if d['same_cluster'] else 'DIFFERENT'}")
        if args.submit:
            line += f"  [{d['base_outcome']} -> {d['subsystem_outcome']}]"
        print(line)

    summary = {
        "jobspecs": len(results),
        "placement_differs": sum(1 for r in results if not r["diff"]["same_cluster"]),
        "base_infeasible": sum(1 for r in results if not r["diff"]["base_feasible"]),
        "subsystem_infeasible": sum(1 for r in results if not r["diff"]["subsystem_feasible"]),
    }
    if args.submit:
        for cond in ("base", "subsystem"):
            summary[f"{cond}_ran"] = sum(1 for r in results if r["diff"][f"{cond}_ran"])
            outcomes = {}
            for r in results:
                o = r["diff"][f"{cond}_outcome"]
                outcomes[o] = outcomes.get(o, 0) + 1
            summary[f"{cond}_outcomes"] = outcomes
        deltas = [r["diff"]["seconds_delta"] for r in results if "seconds_delta" in r["diff"]]
        if deltas:
            summary["paired_runtime_deltas"] = deltas
            summary["median_delta_seconds"] = sorted(deltas)[len(deltas) // 2]

    with open(args.out, "w") as f:
        json.dump({"summary": summary, "results": results}, f, indent=2)
    print()
    print(json.dumps(summary, indent=2))
    print(f"\nwrote {args.out}" + (f", logs under {args.runs}/" if args.submit else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
