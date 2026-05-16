let chartInstance = null;

function renderRun(runId) {
    const run = RUN_DATA.find(r => r.id === runId);
    if (!run) return;

    // Toggle visibility
    document.getElementById('empty-state').style.display = 'none';
    document.getElementById('detail-view').style.display = 'block';

    // Header & Status
    document.getElementById('view-id').innerText = run.id;
    const statusBadge = document.getElementById('view-status');
    statusBadge.innerText = run.status.toUpperCase();
    statusBadge.className = run.status === 'success' ? 'badge bg-success p-2' : 'badge bg-danger p-2';

    // Metrics
    document.getElementById('m-turns').innerText = run.metrics.turns;
    document.getElementById('m-tokens').innerText = run.metrics.total_tokens.toLocaleString();
    document.getElementById('m-prompt').innerText = run.metrics.prompt_tokens.toLocaleString();
    document.getElementById('m-thought').innerText = run.metrics.thought_tokens.toLocaleString();

    // Text Content
    document.getElementById('view-summary').innerText = run.summary;
    document.getElementById('view-reason').innerText = run.reason;

    // Lists
    const issueList = document.getElementById('view-issues');
    issueList.innerHTML = run.issues.length ? '' : '<li class="text-muted">No issues reported</li>';
    run.issues.forEach(issue => {
        const li = document.createElement('li');
        li.className = 'list-group-item text-danger small';
        li.innerText = `⚠️ ${issue}`;
        issueList.appendChild(li);
    });

    const stepList = document.getElementById('view-steps');
    stepList.innerHTML = '';
    run.steps.forEach(step => {
        const li = document.createElement('li');
        li.className = 'list-group-item d-flex justify-content-between align-items-center small';
        li.innerHTML = `<span>${step.rule_name} <br><small class="text-muted">${step.wrapper}</small></span>`;
        const badge = document.createElement('span');
        badge.className = step.success ? 'badge bg-success rounded-pill' : 'badge bg-danger rounded-pill';
        badge.innerText = step.success ? 'OK' : 'FAIL';
        li.appendChild(badge);
        stepList.appendChild(li);
    });

    // Chart
    renderChart(run.turn_history);
}

function renderChart(history) {
    const ctx = document.getElementById('tokenChart').getContext('2d');
    if (chartInstance) chartInstance.destroy();

    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: history.map((_, i) => `Turn ${i + 1}`),
            datasets: [{
                label: 'Prompt Tokens',
                data: history.map(h => h.prompt_tokens),
                borderColor: '#0d6efd',
                tension: 0.1
            }, {
                label: 'Thought Tokens',
                data: history.map(h => h.thought_tokens),
                borderColor: '#6c757d',
                tension: 0.1
            }]
        },
        options: { responsive: true, scales: { y: { beginAtZero: true } } }
    });
}

// Initial Sidebar Load
const listContainer = document.getElementById('run-list');
RUN_DATA.forEach(run => {
    const div = document.createElement('div');
    div.className = 'run-link';
    div.innerHTML = `
        <div class="small fw-bold">${run.id}</div>
        <div class="small ${run.status === 'success' ? 'status-success' : 'status-failure'}">
            ${run.status} • ${run.metrics.turns} turns
        </div>
    `;
    div.onclick = () => {
        document.querySelectorAll('.run-link').forEach(el => el.classList.remove('active'));
        div.classList.add('active');
        renderRun(run.id);
    };
    listContainer.appendChild(div);
});
