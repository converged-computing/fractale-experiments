import os
import subprocess
from pathlib import Path
from collections import Counter, defaultdict


def run_flux_dry_run(script_path):
    """
    Executes flux submit --dry-run and captures metrics.
    """
    cmd = ["flux", "submit", "--dry-run", str(script_path)]
    try:
        result = subprocess.run(
            cmd, 
            capture_output=True, 
            text=True, 
            check=False
        )
        success = (result.returncode == 0)
        # Use the first line of stderr or stdout as the reason for failure
        error_msg = None
        if result.stderr:
            error_msg = result.stderr.strip().split('\n')[0] if result.stderr else "Unknown error"
        return success, result.returncode, error_msg, result.stdout
    except FileNotFoundError:
        return False, -1, "flux command not found", ""

def main(root_dir):
    root_path = Path(root_dir).resolve()
    # experiment -> { 'success': int, 'failure': int, 'reasons': Counter }
    metrics = defaultdict(lambda: {"success": 0, "failure": 0, "reasons": Counter()})
    print(f"Scanning {root_path} for .sh files...")

    paths = list(root_path.rglob("*.sh"))
    for i, script_file in enumerate(paths):
        print(f"{i} of {len(paths)}", end="\r")
        exp_name = script_file.parts[-2]
        # success, ret_code, msg, stdout
        success, _, msg, _ = run_flux_dry_run(script_file)
        if not success:
            print(msg)
        if success:
            metrics[exp_name]["success"] += 1
        else:
            metrics[exp_name]["failure"] += 1
            # Normalize error message to avoid high cardinality (e.g. remove specific paths)
            clean_msg = msg.split(':')[-1].strip() if ':' in msg else msg
            metrics[exp_name]["reasons"][clean_msg] += 1

    print("\n" + "="*60)
    print(f"{'Experiment':<25} | {'Success':<8} | {'Failure':<8}")
    print("-" * 60)
    
    for exp, data in sorted(metrics.items()):
        print(f"{exp:<25} | {data['success']:<8} | {data['failure']:<8}")
        if data['failure'] > 0:
            print("  |_ Failure Reasons:")
            for reason, count in data['reasons'].items():
                print(f"     - [{count}x] {reason}")
    print("="*60)

if __name__ == "__main__":
    import sys
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    main(os.path.join(root, "results", "batch"))