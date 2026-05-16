import json
import os
import glob
from pathlib import Path

def parse_run(run_dir):
    timestamp = os.path.basename(run_dir)
    events_file = glob.glob(f"{run_dir}/*-events.json")[0]
    metrics_file = glob.glob(f"{run_dir}/*-metrics.json")[0]

    with open(events_file, 'r') as f:
        events_data = json.load(f)
    
    with open(metrics_file, 'r') as f:
        metrics_data = json.load(f)

    # 1. Extract Final Summary (usually the last exit event with action: stop)
    final_data = {}
    for event in reversed(events_data.get('events', [])):
        if event.get('type') == 'tool' and event.get('event') == 'exit':
            data = event.get('data', {}).get('outputs', {})
            if data.get('action') == 'stop' or 'summary' in data:
                final_data = data
                break

    # 2. Aggregate Metrics
    total_metrics = {
        "prompt_tokens": 0,
        "candidate_tokens": 0,
        "thought_tokens": 0,
        "total_tokens": 0,
        "turns": len(metrics_data)
    }

    turn_details = []
    for turn in metrics_data:
        m = turn.get('data', {}).get('metrics', {})
        total_metrics["prompt_tokens"] += m.get('prompt_token_count', 0)
        total_metrics["candidate_tokens"] += m.get('candidates_token_count', 0)
        total_metrics["thought_tokens"] += m.get('thoughts_token_count', 0)
        total_metrics["total_tokens"] += m.get('total_token_count', 0)
        
        turn_details.append({
            "timestamp": turn.get('timestamp'),
            "prompt_tokens": m.get('prompt_token_count', 0),
            "thought_tokens": m.get('thoughts_token_count', 0)
        })

    print(total_metrics)

    return {
        "id": timestamp,
        "status": events_data['metadata']['steps'][-1]['agent'],
        "summary": final_data.get('summary', 'No summary provided.'),
        "reason": final_data.get('reason', 'N/A'),
        "issues": final_data.get('issues', []),
        "steps": final_data.get('steps_executed', []),
        "metrics": total_metrics,
        "turn_history": turn_details,
        "snakefile": final_data.get('snakefile_path', 'Snakefile')
    }

def main():
    base_dir = ".fractale"
    run_dirs = [os.path.join(base_dir, d) for d in os.listdir(base_dir) if os.path.isdir(os.path.join(base_dir, d))]
    
    all_runs = []
    for rd in run_dirs:
        try:
            all_runs.append(parse_run(rd))
        except Exception as e:
            print(f"Skipping {rd} due to error: {e}")

    # Sort by timestamp descending
    all_runs.sort(key=lambda x: x['id'], reverse=True)

    # Output JSON for the static site
    with open('web/data.js', 'w') as f:
        f.write("const RUN_DATA = " + json.dumps(all_runs, indent=2) + ";")

    print(f"Processed {len(all_runs)} runs. Open web/index.html to view results.")

if __name__ == "__main__":
    os.makedirs('web', exist_ok=True)
    main()
