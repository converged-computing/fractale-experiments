#!/usr/bin/env python3
"""Build a single-file HTML report from dataset.json.

    build_report.py --data dataset.json --out report.html

No network, no CDN: the data is embedded and the page opens from disk. Built for
repeated runs, so every view aggregates across replicates and shows the spread
rather than a single number.

What it is for. The experiment asks whether describing a job's requirements changes
where it lands and whether that placement is better. "Better" is the application's
own figure of merit, not the exit code, so the comparison view leads with
throughput and only then with seconds.

It also marks pairs that cannot be compared. When the two arms ran different
problem sizes the ratio is arithmetic without meaning, and the page says so instead
of reporting a 510000x speedup.
"""

from __future__ import annotations

import argparse
import json
import statistics

CSS = """
:root {
  --bg:#0f1115; --panel:#171a21; --line:#262b36; --ink:#e6e9ef; --dim:#9aa4b2;
  --accent:#7aa2f7; --good:#9ece6a; --bad:#f7768e; --warn:#e0af68; --same:#565f89;
}
* { box-sizing:border-box }
body { margin:0; background:var(--bg); color:var(--ink);
  font:14px/1.5 ui-sans-serif,-apple-system,Segoe UI,Roboto,sans-serif }
header { padding:20px 24px 12px; border-bottom:1px solid var(--line) }
h1 { margin:0 0 4px; font-size:19px; font-weight:600 }
.sub { color:var(--dim); font-size:13px }
.wrap { padding:18px 24px 60px; max-width:1500px }
.cards { display:flex; flex-wrap:wrap; gap:10px; margin:16px 0 22px }
.card { background:var(--panel); border:1px solid var(--line); border-radius:8px;
  padding:11px 14px; min-width:118px }
.card .n { font-size:21px; font-weight:600 }
.card .k { color:var(--dim); font-size:11px; text-transform:uppercase;
  letter-spacing:.06em }
h2 { font-size:15px; margin:26px 0 10px; font-weight:600 }
h2 .hint { color:var(--dim); font-weight:400; font-size:12px; margin-left:8px }
table { border-collapse:collapse; width:100%; background:var(--panel);
  border:1px solid var(--line); border-radius:8px; overflow:hidden }
th,td { padding:7px 10px; text-align:left; border-bottom:1px solid var(--line);
  font-size:13px; vertical-align:top }
th { color:var(--dim); font-weight:600; font-size:11px; text-transform:uppercase;
  letter-spacing:.05em; cursor:pointer; user-select:none; white-space:nowrap }
th:hover { color:var(--ink) }
tr:last-child td { border-bottom:none }
tbody tr:hover { background:#1c2028 }
td.num { text-align:right; font-variant-numeric:tabular-nums;
  font-family:ui-monospace,SFMono-Regular,Menlo,monospace }
.pill { display:inline-block; padding:1px 7px; border-radius:10px; font-size:11px;
  border:1px solid }
.ok   { color:var(--good); border-color:#2c4a1e; background:#16260f }
.fail { color:var(--bad);  border-color:#4a1e28; background:#260f14 }
.miss { color:var(--warn); border-color:#4a3a1e; background:#261e0f }
.diff { color:var(--accent); border-color:#24365e; background:#111a2e }
.same { color:var(--same); border-color:#2b3252; background:#141827 }
.win-s { color:var(--good) } .win-b { color:var(--bad) } .win-t { color:var(--dim) }
.bar { display:inline-block; height:7px; border-radius:3px; background:var(--accent);
  vertical-align:middle }
.bar.b { background:var(--bad) }
button.tab { background:var(--panel); color:var(--dim); border:1px solid var(--line);
  padding:6px 13px; border-radius:6px; cursor:pointer; font-size:13px }
button.tab.on { color:var(--ink); border-color:var(--accent) }
.tabs { display:flex; gap:8px; margin:0 0 16px; flex-wrap:wrap }
.hide { display:none }
pre { background:#0b0d11; border:1px solid var(--line); border-radius:6px;
  padding:10px; overflow:auto; max-height:340px; font-size:12px;
  font-family:ui-monospace,SFMono-Regular,Menlo,monospace; color:#c8d0dc }
details { background:var(--panel); border:1px solid var(--line); border-radius:8px;
  margin:8px 0; padding:0 }
summary { padding:9px 13px; cursor:pointer; font-size:13px }
summary:hover { background:#1c2028 }
details .body { padding:0 13px 13px }
.note { color:var(--dim); font-size:12px; margin:6px 0 12px }
.warnbox { border:1px solid #4a3a1e; background:#1d1710; color:var(--warn);
  padding:9px 12px; border-radius:6px; font-size:12px; margin:8px 0 }
.spark { display:block }
.kv { color:var(--dim) } .kv b { color:var(--ink); font-weight:600 }
"""

JS = r"""
const D = DATA;
const R = D.records, S = D.summary;
const fmt = (v, d=3) => v === null || v === undefined ? '\u2013'
  : (Math.abs(v) >= 1e5 || (Math.abs(v) > 0 && Math.abs(v) < 1e-3))
    ? v.toExponential(2) : (+v).toFixed(d).replace(/\.?0+$/,'');
const pill = (c, t) => `<span class="pill ${c}">${t}</span>`;
const statusPill = s => pill(
  s === 'ok' ? 'ok' : s === 'failed' ? 'fail' : 'miss', s || '\u2013');

function show(id) {
  document.querySelectorAll('.panel').forEach(p => p.classList.add('hide'));
  document.getElementById(id).classList.remove('hide');
  document.querySelectorAll('button.tab').forEach(b =>
    b.classList.toggle('on', b.dataset.for === id));
}

/* sortable tables: numeric when the column is numeric, else lexical */
function sortable(table) {
  table.querySelectorAll('th').forEach((th, i) => th.onclick = () => {
    const body = table.tBodies[0];
    const rows = [...body.rows];
    const dir = th.dataset.dir === 'asc' ? -1 : 1;
    table.querySelectorAll('th').forEach(o => delete o.dataset.dir);
    th.dataset.dir = dir === 1 ? 'asc' : 'desc';
    const val = r => {
      const c = r.cells[i];
      const raw = c.dataset.sort !== undefined ? c.dataset.sort : c.textContent;
      const n = parseFloat(raw);
      return isNaN(n) ? raw.toLowerCase() : n;
    };
    rows.sort((a, b) => {
      const x = val(a), y = val(b);
      return (x > y ? 1 : x < y ? -1 : 0) * dir;
    });
    rows.forEach(r => body.appendChild(r));
  });
}

/* ---------- comparison: the headline view ---------- */
function comparisons() {
  const byApp = {};
  S.comparisons.forEach(c => (byApp[c.app] = byApp[c.app] || []).push(c));
  let h = '';
  for (const app of Object.keys(byApp).sort()) {
    const cs = byApp[app];
    const first = cs[0];
    const clusters = [...new Set(cs.map(c => `${c.base_cluster} \u2192 ${c.subsystem_cluster}`))];
    const anyDiff = cs.some(c => c.differs);

    /* a pair is not comparable if a size-like metric differs between arms */
    const sizeKeys = ['hpl_n', 'points', 'cg_iterations'];
    let incomparable = null;
    for (const c of cs) for (const k of sizeKeys) {
      const f = (c.fom || {})[k];
      if (f && f.base !== f.subsystem) {
        incomparable = `${k} differs (${fmt(f.base)} vs ${fmt(f.subsystem)}): the ` +
          `two arms did not solve the same problem, so the ratios below are not a ` +
          `comparison of placements`;
      }
    }

    const runtimes = cs.filter(c => c.runtime_ratio).map(c => c.runtime_ratio);
    h += `<details ${cs.length ? 'open' : ''}><summary><b>${app}</b> `
      + (anyDiff ? pill('diff', 'placement differs') : pill('same', 'same cluster'))
      + ` <span class="kv">${clusters.join(' | ')}</span>`
      + (runtimes.length ? ` <span class="kv">runtime ratio <b>${
          fmt(statistics_median(runtimes))}</b></span>` : '')
      + `</summary><div class="body">`;
    if (incomparable) h += `<div class="warnbox">${incomparable}</div>`;

    /* runtime per replicate */
    h += `<table><thead><tr><th>replicate</th><th>base cluster</th>
      <th>subsystem cluster</th><th>base</th><th>subsystem</th>
      <th>base runtime</th><th>subsystem runtime</th><th>ratio</th>
      <th>attempts</th></tr></thead><tbody>`;
    cs.forEach(c => {
      h += `<tr><td class="num">${c.replicate}</td>
        <td>${c.base_cluster || '\u2013'}</td><td>${c.subsystem_cluster || '\u2013'}</td>
        <td>${statusPill(c.base_status)}</td><td>${statusPill(c.subsystem_status)}</td>
        <td class="num">${fmt(c.base_runtime_s)}</td>
        <td class="num">${fmt(c.subsystem_runtime_s)}</td>
        <td class="num" data-sort="${c.runtime_ratio || ''}">${
          c.runtime_ratio ? ratioCell(c.runtime_ratio, false) : '\u2013'}</td>
        <td class="num">${c.base_attempts} / ${c.subsystem_attempts}</td></tr>`;
    });
    h += `</tbody></table>`;

    /* figures of merit, aggregated over replicates */
    const keys = [...new Set(cs.flatMap(c => Object.keys(c.fom || {})))]
      .filter(k => !sizeKeys.includes(k));
    if (keys.length) {
      h += `<h2 style="font-size:13px">figures of merit
        <span class="hint">the application's own measure, which is what "better"
        means here</span></h2>`;
      h += `<table><thead><tr><th>metric</th><th>unit</th><th>better</th>
        <th>base</th><th>subsystem</th><th>ratio</th><th>winner</th>
        <th>replicates</th></tr></thead><tbody>`;
      keys.forEach(k => {
        const vals = cs.map(c => (c.fom || {})[k]).filter(Boolean);
        if (!vals.length) return;
        const b = vals.map(v => v.base), s = vals.map(v => v.subsystem);
        const rs = vals.map(v => v.ratio).filter(x => x !== undefined);
        const dir = vals[0].higher_is_better;
        const wins = vals.map(v => v.winner);
        const win = wins.every(w => w === wins[0]) ? wins[0] : 'mixed';
        h += `<tr><td>${k}</td><td class="kv">${vals[0].unit}</td>
          <td class="kv">${dir === null ? '\u2013' : dir ? 'higher' : 'lower'}</td>
          <td class="num">${fmt(statistics_median(b))}${spread(b)}</td>
          <td class="num">${fmt(statistics_median(s))}${spread(s)}</td>
          <td class="num" data-sort="${rs.length ? statistics_median(rs) : ''}">${
            rs.length ? ratioCell(statistics_median(rs), dir) : '\u2013'}</td>
          <td class="${win === 'subsystem' ? 'win-s' : win === 'base' ? 'win-b' : 'win-t'}">${win}</td>
          <td class="num">${vals.length}</td></tr>`;
      });
      h += `</tbody></table>`;
    }
    h += `</div></details>`;
  }
  return h;
}

function spread(xs) {
  if (xs.length < 2) return '';
  const lo = Math.min(...xs), hi = Math.max(...xs);
  return ` <span class="kv">[${fmt(lo)}\u2013${fmt(hi)}]</span>`;
}
function statistics_median(xs) {
  const a = [...xs].sort((x, y) => x - y), n = a.length;
  return n % 2 ? a[(n - 1) / 2] : (a[n / 2 - 1] + a[n / 2]) / 2;
}
/* a ratio, drawn so the direction is visible: subsystem/base, and whether that
   is an improvement depends on the metric */
function ratioCell(r, higherIsBetter) {
  const better = higherIsBetter === null || higherIsBetter === undefined
    ? null : (higherIsBetter ? r > 1 : r < 1);
  const w = Math.min(90, Math.abs(Math.log2(r || 1)) * 26);
  const cls = better === null ? '' : better ? '' : 'b';
  return `${fmt(r)} <span class="bar ${cls}" style="width:${w}px"></span>`;
}

/* ---------- placement ---------- */
function placement() {
  const rows = S.comparisons;
  let h = `<div class="note">Where each arm was matched. This is measured before
    dispatch, so it stands whether or not the job then ran.</div>`;
  h += `<table id="tplace"><thead><tr><th>app</th><th>replicate</th>
    <th>base</th><th>subsystem</th><th>differs</th></tr></thead><tbody>`;
  rows.forEach(c => {
    h += `<tr><td>${c.app}</td><td class="num">${c.replicate}</td>
      <td>${c.base_cluster || '\u2013'}</td><td>${c.subsystem_cluster || '\u2013'}</td>
      <td data-sort="${c.differs ? 1 : 0}">${
        c.differs ? pill('diff', 'yes') : pill('same', 'no')}</td></tr>`;
  });
  h += `</tbody></table>`;

  /* how often each cluster was chosen, per arm */
  const tally = {};
  R.forEach(r => {
    if (!r.cluster) return;
    tally[r.cluster] = tally[r.cluster] || { base: 0, subsystem: 0 };
    tally[r.cluster][r.condition]++;
  });
  h += `<h2>cluster usage <span class="hint">a concentration here is worth
    knowing: it means the constraints are not discriminating</span></h2>`;
  h += `<table><thead><tr><th>cluster</th><th>base</th><th>subsystem</th>
    </tr></thead><tbody>`;
  Object.keys(tally).sort().forEach(k => {
    h += `<tr><td>${k}</td><td class="num">${tally[k].base}</td>
      <td class="num">${tally[k].subsystem}</td></tr>`;
  });
  return h + `</tbody></table>`;
}

/* ---------- attempts: the agent's path to a launch ---------- */
function attempts() {
  let h = `<div class="note">Every launch the agent tried, in order, with the
    reason it gave. This is the experiment's subject, not a side effect.</div>`;
  R.filter(r => r.attempts.length).sort((a, b) =>
      a.app.localeCompare(b.app) || a.condition.localeCompare(b.condition))
    .forEach(r => {
      h += `<details><summary><b>${r.app}</b> <span class="kv">${r.condition}
        &middot; ${r.cluster || '\u2013'} &middot; replicate ${r.replicate}</span>
        ${statusPill(r.status)} <span class="kv">${r.attempts.length} attempt(s)`
        + (r.runtime_s ? `, ran in <b>${fmt(r.runtime_s)}s</b>` : '')
        + `</span></summary><div class="body">`;
      if (r.reason) h += `<div class="warnbox">${escapeHtml(r.reason)}</div>`;
      h += `<table><thead><tr><th>#</th><th>status</th><th>rc</th>
        <th>exception</th><th>runtime</th><th>nodes</th><th>tasks</th>
        <th>args changed</th><th>why</th></tr></thead><tbody>`;
      r.attempts.forEach(a => {
        h += `<tr><td class="num">${a.n}</td><td>${statusPill(a.status)}</td>
          <td class="num">${a.rc ?? '\u2013'}</td>
          <td>${a.exception || '\u2013'}</td>
          <td class="num">${fmt(a.runtime_s)}</td>
          <td class="num">${a.nodes ?? '\u2013'}</td>
          <td class="num">${a.tasks ?? '\u2013'}</td>
          <td>${a.args_changed ? escapeHtml(a.args_changed) : '\u2013'}</td>
          <td class="kv">${escapeHtml((a.why || '').slice(0, 160))}</td></tr>`;
      });
      h += `</tbody></table>`;
      if (r.stdout_tail) h += `<h2 style="font-size:13px">application output</h2>
        <pre>${escapeHtml(r.stdout_tail)}</pre>`;
      if (r.stderr_tail) h += `<h2 style="font-size:13px">stderr</h2>
        <pre>${escapeHtml(r.stderr_tail)}</pre>`;
      h += `</div></details>`;
    });
  return h;
}

/* ---------- outcomes ---------- */
function outcomes() {
  let h = `<div class="note">The transcript's verdict, not the object's. A
    MiniCluster reaching a terminal state does not mean the workload ran, and
    "no-log" means the capture failed, which is not a statement about the run.
    </div>`;
  h += `<table id="tout"><thead><tr><th>app</th><th>condition</th><th>replicate</th>
    <th>cluster</th><th>status</th><th>attempts</th><th>runtime</th>
    <th>wall</th><th>log</th></tr></thead><tbody>`;
  R.sort((a, b) => a.app.localeCompare(b.app) ||
      a.condition.localeCompare(b.condition) || a.replicate - b.replicate)
   .forEach(r => {
    h += `<tr><td>${r.app}</td><td>${r.condition}</td>
      <td class="num">${r.replicate}</td><td>${r.cluster || '\u2013'}</td>
      <td>${statusPill(r.status)}</td>
      <td class="num">${r.attempts.length}</td>
      <td class="num">${fmt(r.runtime_s)}</td>
      <td class="num">${fmt(r.wall_s, 1)}</td>
      <td class="num">${r.log_chars}</td></tr>`;
  });
  return h + `</tbody></table>`;
}

function escapeHtml(s) {
  return String(s ?? '').replace(/[&<>"']/g, c =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
}

document.getElementById('cmp').innerHTML = comparisons();
document.getElementById('place').innerHTML = placement();
document.getElementById('att').innerHTML = attempts();
document.getElementById('out').innerHTML = outcomes();
document.querySelectorAll('table').forEach(sortable);
show('cmp');
"""


def build(data: dict) -> str:
    s = data["summary"]
    reps = s["replicates"]
    cards = [
        ("replicates", len(reps)),
        ("apps", s["apps"]),
        ("paired runs", s["pairs"]),
        ("placement differs", f"{s['placement_differs']}/{s['with_both_placements']}"),
        ("paired runtimes", s["paired_runtimes"]),
        ("median delta", f"{s['median_runtime_delta_s']}s"
            if s["median_runtime_delta_s"] is not None else "-"),
    ]
    for cond in ("base", "subsystem"):
        ok = (s["outcomes"].get(cond) or {}).get("ok", 0)
        tot = sum((s["outcomes"].get(cond) or {}).values())
        cards.append((f"{cond} ran", f"{ok}/{tot}"))

    card_html = "".join(
        f'<div class="card"><div class="n">{v}</div><div class="k">{k}</div></div>'
        for k, v in cards)

    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>subsystem scheduling &mdash; results</title>
<style>{CSS}</style></head><body>
<header>
  <h1>Subsystem scheduling: placement and application performance</h1>
  <div class="sub">Each application submitted twice &mdash; once with no
    requirements (<b>base</b>) and once describing what it needs
    (<b>subsystem</b>) &mdash; then compared on where it landed and how well it
    ran there. Figures of merit come from each application's own output.</div>
</header>
<div class="wrap">
  <div class="cards">{card_html}</div>
  <div class="tabs">
    <button class="tab" data-for="cmp" onclick="show('cmp')">comparison</button>
    <button class="tab" data-for="place" onclick="show('place')">placement</button>
    <button class="tab" data-for="att" onclick="show('att')">attempts &amp; output</button>
    <button class="tab" data-for="out" onclick="show('out')">every run</button>
  </div>
  <div id="cmp" class="panel"></div>
  <div id="place" class="panel hide"></div>
  <div id="att" class="panel hide"></div>
  <div id="out" class="panel hide"></div>
</div>
<script>const DATA = {json.dumps(data)};</script>
<script>{JS}</script>
</body></html>
"""


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data", default="dataset.json")
    ap.add_argument("--out", default="report.html")
    args = ap.parse_args()

    data = json.load(open(args.data))
    html = build(data)
    with open(args.out, "w") as f:
        f.write(html)
    print(f"wrote {args.out} ({len(html) // 1024} KiB), "
          f"{len(data['records'])} records over "
          f"{len(data['summary']['replicates'])} replicate(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
