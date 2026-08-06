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
import re
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
        # ?trace=1 returns the decision alongside the ranking: every cluster
        # considered, what each rejected one was missing, the score in terms, and
        # whether the winner was a tie the shuffle happened to break. Without it a
        # placement can be recorded but not accounted for.
        resp = _req(f"{fluxq}/v1/jobs/satisfy?trace=1", js) or []
        trace = {}
        if isinstance(resp, dict):
            cands, trace = resp.get("candidates") or [], resp.get("trace") or {}
        else:
            cands = resp
    except urllib.error.HTTPError as e:
        return {"error": f"HTTP {e.code}: {e.read().decode()[:200]}", "feasible": 0, "cluster": None}
    except Exception as e:  # noqa: BLE001
        return {"error": str(e), "feasible": 0, "cluster": None}
    if not cands:
        return {"feasible": 0, "cluster": None, "matched": [], "score": None,
                "trace": trace}
    top = cands[0]
    return {"feasible": len(cands), "cluster": top.get("cluster"), "trace": trace,
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


def _kubectl(*args, timeout=40):
    """kubectl, or an empty result when it cannot be run.

    A missing binary, an unreachable context or a slow API server must not end the
    run: the log is evidence ABOUT the job, and losing it is not a reason to lose
    the job's own result as well.
    """
    try:
        return subprocess.run(["kubectl", *args], capture_output=True,
                              text=True, timeout=timeout)
    except (FileNotFoundError, subprocess.TimeoutExpired, OSError) as e:
        class Unavailable:
            returncode, stdout = 1, ""
            stderr = f"kubectl unavailable: {e}"
        return Unavailable()


def save_broker_log(cluster, name, path):
    """Persist the lead broker's terminal output: pod index 0 of the MiniCluster.

    fluxq's job log is the object's status, not what the application printed.
    Rank 0 is where flux-secretary writes its transcript and where the workload's
    own stdout lands, so without this a run leaves no record of what happened
    inside it. Captured before cleanup, since deleting the object takes the pods.
    """
    text = ""
    if cluster and name:
        pods = _kubectl(
            "--context", cluster, "get", "pods",
            "-l", f"job-name={name}", "-o",
            "jsonpath={range .items[*]}{.metadata.name}{\"\\n\"}{end}")
        # <minicluster>-<index>-<hash>: index 0 is the broker
        rank0 = next(
            (p for p in pods.stdout.split() if p.startswith(f"{name}-0-")), "")
        if rank0:
            r = _kubectl("--context", cluster, "logs", rank0,
                 "--all-containers", "--tail=-1")
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
    out = _kubectl("--context", cluster, "get", "pods",
         "-l", f"job-name={name}", "-o", "json", "--request-timeout=20s")
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
            lg = _kubectl("--context", cluster, "logs", first,
                 "--all-containers", "--tail=20", "--request-timeout=20s")
            if "exec format error" in (lg.stdout + lg.stderr):
                return "exec format error: the image is built for another architecture"
    return ""


def agent_mode(path):
    """The mode the run ENDED in, and how many API retries it took.

    The transcript emits a mode line at the start and another on fallback, so the
    first says "agent" even when the API dropped and the deterministic ladder took
    over. Reading the first hides the outage entirely. That distinction matters:
    the ladder varies task layout only, so a failure needing an environment change
    cannot be recovered without the agent.
    """
    try:
        text = re.sub(r"\x1b\[[0-9;]*m", "",
                      open(path, errors="replace").read())
    except OSError:
        return None, 0
    modes = re.findall(r"FLUXSEC mode mode=(\S+)", text)
    return (modes[-1] if modes else None), len(re.findall(r"FLUXSEC api_retry ", text))


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
        r = _kubectl("--context", cluster, "delete", kind, name,
             "--ignore-not-found", "--wait=false")
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
    # The predicted cluster and the one used should agree. When they do not, the
    # dry run and the dispatch reached different answers, which is worth seeing
    # rather than discovering later in the analysis.
    inner, runtime_s, attempts, reason = secretary_result(base + ".broker.log")
    mode, api_retries = agent_mode(base + ".broker.log")
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
            # How the cluster above was actually chosen. This is the dispatch
            # decision, not the /satisfy dry run: satisfy ranks again and can
            # reach a different answer, so its trace routinely names a cluster the
            # job did not use. Both are kept, and this is the authoritative one.
            "decision": field(rec, "Decision"),
            # The mode the secretary ENDED in, and how many API retries it took, so
            # an outage is visible while the run happens rather than inferred from
            # the logs afterwards.
            "agent_mode": mode,
            "api_retries": api_retries,
            "note": field(rec, "Note"),               # driver's reason for failure
            "suggestion": field(rec, "Suggestion"),   # fluxq's reconfiguration hint
            "reschedules": field(rec, "Reschedules", default=0),
            "log_bytes": log_bytes, "log": base + ".log",
            "broker_bytes": broker_bytes, "broker_log": base + ".broker.log",
            "manifest": (base + ".manifest.yaml") if artifact.strip() else None}


def report_run(cond, entry, tally):
    """Print what happened, while it is happening.

    Every failure this experiment hit was diagnosable from data the harness already
    had and discarded until the run finished: a cluster that ranked top and never
    took a job, an agent that lost its API and fell back to a ladder that could not
    fix the failure, a workload that never started while the MiniCluster reported
    COMPLETED. Hours were spent before any of it was visible.
    """
    r, p = entry.get("run") or {}, entry.get("placement") or {}
    dec = r.get("decision") or {}
    ranked = [x.get("cluster") for x in (dec.get("ranked") or [])]
    ran_on = r.get("cluster")
    if ran_on:
        tally[ran_on] = tally.get(ran_on, 0) + 1

    bits = [str(r.get("outcome")), f"{r.get('seconds')}s"]
    if r.get("runtime_s") is not None:
        # the job's own runtime from the flux eventlog, not the harness's poll
        bits.append(f"job={r['runtime_s']}s")
    if r.get("attempts"):
        bits.append(f"attempts={r['attempts']}")
    if r.get("log_bytes") is not None:
        bits.append(f"log={r.get('log_bytes', 0)}B")
    print(f"    {cond:9} {'  '.join(bits)}")

    # Where it went, and whether that was the top of the ranking. A top-ranked
    # cluster losing the allocation is how placement silently stops following the
    # score, and it is invisible in the outcome alone.
    place = f"on {ran_on or '-'}"
    if ranked:
        place += f"   {len(ranked)} feasible"
        if ran_on and ranked[0] != ran_on:
            place += f", but {ranked[0]} ranked first"
        if dec.get("tied_at_top") and len(dec["tied_at_top"]) > 1:
            place += f", {len(dec['tied_at_top'])} tied"
    elif p.get("feasible"):
        place += f"   satisfy said {p['feasible']} feasible"
    print(f"              {place}")

    # why the others were excluded: the actual subject of the experiment
    rej = dec.get("rejected") or []
    if rej:
        why = ", ".join(
            f"{str(x.get('cluster')).replace('sched-', '')}:"
            f"{'+'.join(x.get('missing') or ['?'])}" for x in rej[:6])
        print(f"              rejected {why}")

    # the agent, and whether it kept its API
    if r.get("agent_mode"):
        line = f"              agent {r['agent_mode']}"
        if r.get("api_retries"):
            line += f", {r['api_retries']} api retry/ies"
        print(line)

    if r.get("app_reason"):
        print(f"              reason {str(r['app_reason'])[:96]}")
    if r.get("note") and r.get("note") != "MiniCluster applied":
        print(f"              note {str(r['note'])[:96]}")
    if r.get("cleaned"):
        print(f"              cleaned {','.join(r['cleaned'])}")


def run_iteration(args, jobs, runs_dir, out_path, label=""):
    """One full pass over the jobspecs, writing its own runs and results.json.

    Each iteration is self contained: its logs, job records and summary live
    together, so a pass can be read, re-parsed or thrown away on its own. The
    analysis tooling takes several such directories and treats them as replicates.
    """
    results = []
    # Cluster usage as the iteration proceeds. A cluster on zero is the
    # signal that it is registered, feasible, and not taking work.
    tally = {}
    for app, js in jobs.items():
        rec = {"app": app, "requires": sorted(js.get("requires") or {})}
        try:
            rec["nodes"] = js["resources"][0].get("count")
        except (KeyError, IndexError):
            rec["nodes"] = None

        if args.submit:
            print(f"{label}{app} ...")
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
                                       os.path.join(runs_dir, app), cond,
                                       args.timeout, args.poll)
                    report_run(cond, entry, tally)
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

    if args.submit and tally:
        print()
        print("  cluster usage this iteration:")
        total = sum(tally.values())
        for c in sorted(tally, key=lambda x: -tally[x]):
            print(f"    {c:28} {tally[c]:>3}  {tally[c] / total * 100:4.0f}%  "
                  + "#" * tally[c])
        # A registered cluster that took nothing is the failure that cost this
        # experiment two full runs: feasible, top-ranked, and never dispatched.
        seen = set()
        for r in results:
            for arm in ("base", "subsystem"):
                dec = ((r.get(arm) or {}).get("run") or {}).get("decision") or {}
                for key in ("ranked", "rejected"):
                    for x in dec.get(key) or []:
                        seen.add(x.get("cluster"))
        idle = sorted(c for c in seen if c and c not in tally)
        if idle:
            print(f"    NOT USED: {', '.join(idle)}")
            print("    Those were considered and never dispatched to. Check they can")
            print("    take a job before spending another iteration.")

    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    with open(out_path, "w") as f:
        json.dump({"summary": summary, "results": results}, f, indent=2)
    print()
    print(json.dumps(summary, indent=2))
    print(f"\nwrote {out_path}" + (f", logs under {runs_dir}/" if args.submit else ""))
    return summary


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
    p.add_argument("--iterations", type=int, default=1,
                   help="repeat the whole experiment N times. Each pass writes "
                        "runs/<i>/ and runs/<i>/results.json, so the passes can be "
                        "compared as replicates and one bad pass can be dropped")
    # Default None, not 0. Zero is a legitimate thing to ask for, and using it as
    # the sentinel made "--start-iteration 0" indistinguishable from not passing
    # the flag at all: the run took the flat layout and wrote no runs/0/ and no
    # results.json under it.
    p.add_argument("--start-iteration", type=int, default=None,
                   help="first iteration number. Passing this always writes "
                        "runs/<i>/, including --start-iteration 0, so passes can "
                        "be added to an existing set without overwriting it")
    args = p.parse_args(argv)

    jobs = load_jobspecs(args.jobspecs)
    if args.only:
        keep = {s.strip() for s in args.only.split(",")}
        jobs = {k: v for k, v in jobs.items() if k in keep}
    if not jobs:
        print(f"no jobspecs under {args.jobspecs}", file=sys.stderr)
        return 1

    # The flat layout only when nothing about iterations was asked for, so
    # existing invocations and tooling are unchanged.
    if args.iterations == 1 and args.start_iteration is None:
        # run_iteration returns its summary; the process exit code is separate.
        run_iteration(args, jobs, args.runs, args.out)
        return 0

    first = args.start_iteration or 0
    last = first + args.iterations
    summaries = []
    for i in range(first, last):
        runs_dir = os.path.join(args.runs, str(i))
        out_path = os.path.join(runs_dir, "results.json")
        n = i - first + 1
        print()
        print("=" * 72)
        print(f"iteration {i}  ({n} of {args.iterations})  -> {runs_dir}")
        print("=" * 72)
        started = time.time()
        try:
            summary = run_iteration(args, jobs, runs_dir, out_path,
                                    label=f"[{i}] ")
        except KeyboardInterrupt:
            print(f"\ninterrupted during iteration {i}; "
                  f"{len(summaries)} complete pass(es) are on disk")
            break
        summary["iteration"] = i
        summary["wall_seconds"] = round(time.time() - started, 1)
        summaries.append(summary)

    # An index across the passes, so a reader does not have to open ten files to
    # see whether they agree.
    index = {
        "iterations": [s["iteration"] for s in summaries],
        "runs_root": args.runs,
        "per_iteration": summaries,
    }
    if summaries:
        for key in ("placement_differs", "base_ran", "subsystem_ran"):
            vals = [s[key] for s in summaries if key in s]
            if vals:
                index[f"{key}_by_iteration"] = vals
                index[f"{key}_median"] = sorted(vals)[len(vals) // 2]
        wall = [s["wall_seconds"] for s in summaries]
        index["wall_seconds_total"] = round(sum(wall), 1)

    index_path = os.path.join(args.runs, "index.json")
    os.makedirs(args.runs, exist_ok=True)
    with open(index_path, "w") as f:
        json.dump(index, f, indent=2)

    print()
    print("=" * 72)
    print(f"{len(summaries)} iteration(s) complete in "
          f"{index.get('wall_seconds_total', 0)}s")
    for s in summaries:
        bits = [f"iteration {s['iteration']}",
                f"differs {s.get('placement_differs')}/{s.get('jobspecs')}"]
        if "base_ran" in s:
            bits.append(f"ran {s.get('base_ran')}/{s.get('subsystem_ran')}")
        bits.append(f"{s['wall_seconds']}s")
        print("  " + "  ".join(bits))
    print()
    print(f"wrote {index_path}")
    print("analyse every pass together:")
    dirs = " ".join(os.path.join(args.runs, str(s["iteration"])) for s in summaries)
    print(f"  python3 parse_runs.py --runs {dirs} --out dataset.json")
    print( "  python3 build_report.py --data dataset.json --out report.html")
    return 0


if __name__ == "__main__":
    sys.exit(main())
