import json
import os
import glob
from collections import defaultdict


def try_parse_json(value):
    if isinstance(value, str):
        try:
            return json.loads(value)
        except:
            return value
    return value


def prepare_data(root_dir, output_file="data.js"):
    experiments = defaultdict(list)

    # Path pattern: results/{exp_id}/{path...}/submit.sh-flux-result.json
    result_files = glob.glob(
        os.path.join(root_dir, "**/*-flux-result.json"), recursive=True
    )

    print(f"Found {len(result_files)} result files.")

    for path in result_files:
        parts = path.split(os.sep)
        try:
            results_idx = parts.index("results")
            exp_id = parts[results_idx + 1]
        except (ValueError, IndexError):
            exp_id = "unknown"

        try:
            with open(path, "r") as f:
                data = json.load(f)

            events = data.get("events", [])
            metrics_list = data.get("metrics", [])
            slurm_source = data["plan"]["steps"][0]["inputs"]["script"]

            # 2. FLUX & STATUS EXTRACTION
            # We need to extract the jobspec from the latest transform step
            flux_output = None
            final_status = None

            # Find the latest transform and validation steps
            for ev in reversed(events):
                if (
                    ev.get("data", {}).get("outputs", {}).get("valid") in [True, False]
                    and final_status is None
                ):
                    is_valid = ev.get("data", {}).get("outputs", {}).get("valid")
                    if is_valid:
                        final_status = "Valid"
                    else:
                        final_status = "Invalid"
                if flux_output is None:
                    flux_output = ev.get("data", {}).get("outputs", {}).get("jobspec")

            if flux_output is None or final_status == "Unknown":
                print("ISSUE getting flux output")
                flux_output = "noop"

            # 3. METRICS
            total_time = (
                (events[-1]["timestamp"] - events[0]["timestamp"])
                if len(events) > 1
                else 0.0
            )
            token_total = sum(
                [
                    m.get("data", {}).get("metrics", {}).get("total_token_count", 0)
                    or m.get("data", {}).get("metrics", {}).get("total_tokens", 0)
                    for m in metrics_list
                ]
            )
            valid_events = [
                x
                for x in events
                if x["step"] in ["transform", "validate", "manual-validate", "manual_validate"] and x["event"] == "exit"
            ]
            step_count = len(valid_events)
            print(valid_events)

            # Populate entry matching the keys index.html expects
            experiments[exp_id].append(
                {
                    "id": os.path.basename(path).replace("-flux-result.json", ""),
                    "filename": data["filename"],
                    "status": final_status,
                    "total_time": total_time,
                    "step_count": step_count,
                    "slurm": slurm_source,
                    "flux": flux_output,
                    "events": events,
                    "token_total": token_total,
                }
            )

        except Exception as e:
            print(f"Error parsing {path}: {e}")

    # Sort attempts by ID
    for exp_id in experiments:
        experiments[exp_id].sort(key=lambda x: x["filename"])

    # Metadata for counts
    experiment_metadata = {
        exp_id: len(attempts) for exp_id, attempts in experiments.items()
    }

    with open(output_file, "w") as f:
        f.write("window.experiment_data = ")
        json.dump(experiments, f, indent=2)
        f.write(";\nwindow.experiment_metadata = ")
        json.dump(experiment_metadata, f, indent=2)
        f.write(";")

    print(f"Generated {output_file}")


if __name__ == "__main__":
    prepare_data(os.getcwd())
