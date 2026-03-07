import json
import os
import glob

def try_parse_json(value):
    """If value is a JSON string, parse it. Otherwise return it as is."""
    if isinstance(value, str):
        try:
            return json.loads(value)
        except (json.JSONDecodeError, TypeError):
            return value
    return value

def prepare_data(root_dir, output_file="data.js"):
    experiments = {}
    event_files = glob.glob(os.path.join(root_dir, "**/*-events.json"), recursive=True)
    
    print(f"Found {len(event_files)} conversion attempts. Processing...")

    for event_path in event_files:
        parent_dir = os.path.dirname(event_path)
        exp_id = os.path.basename(parent_dir) # e.g., 'gemini'
        prefix = os.path.basename(event_path).replace("-events.json", "")
        metrics_path = os.path.join(parent_dir, f"{prefix}-metrics.json")
        
        if not os.path.exists(metrics_path):
            continue

        try:
            with open(event_path, 'r') as f:
                raw_data = json.load(f)
                # Ensure events is a list
                events = raw_data.get("events", []) if isinstance(raw_data, dict) else raw_data
            
            with open(metrics_path, 'r') as f:
                metrics_list = json.load(f)
            
            slurm_source = "Source script not found."
            m_list = metrics_list if isinstance(metrics_list, list) else [metrics_list]
            for m in m_list:
                p = m.get("data", {}).get("prompt", "")
                if p and ("#SBATCH" in p or "#!/bin/bash" in p):
                    marker = "#!/bin/bash" if "#!/bin/bash" in p else "#SBATCH"
                    slurm_source = p[p.find(marker):].strip()
                    break

            flux_output = ""
            
            for e in events:
                data = e.get("data", {})
                if "output" in data: data["output"] = try_parse_json(data["output"])
                if "outputs" in data: data["outputs"] = try_parse_json(data["outputs"])
                
                # Check for Jobspec
                if e.get("step") == "transform":
                    out = data.get("output") or data.get("outputs") or {}
                    flux_output = out.get("jobspec", "") if isinstance(out, dict) else ""
                
                # Check for Validity (any validate step)
                out = data.get("output") or data.get("outputs") or {}
                if isinstance(out, dict) and out.get("valid") is True:
                    final_status = "Valid"
                elif isinstance(out, dict) and out.get("valid") is False:
                    final_status = "Invalid"
                elif isinstance(out, dict) and "valid" not in out:
                    final_status = "NA"

            relevant_steps = ['transform', 'validate', 'validate_flux_jobspec', 'manual_validate']
            step_count = sum(1 for e in events if e.get("step") in relevant_steps and e.get('event') == "exit")
            total_time = events[-1]['timestamp'] - events[0]['timestamp']
            token_total = sum([x['data']['metrics'].get('total_token_count') or x['data']['metrics'].get('total_tokens') for x in m_list])
            entry = {
                "id": prefix,
                "status": final_status,
                "total_time": total_time,
                "step_count": step_count,
                "slurm": slurm_source,
                "flux": flux_output,
                "events": events,
                "token_total": token_total,
            }

            if exp_id not in experiments: experiments[exp_id] = []
            experiments[exp_id].append(entry)

        except Exception as e:
            print(f"Error parsing {prefix}: {e}")

    with open(output_file, 'w') as f:
        f.write("window.experiment_data = ")
        json.dump(experiments, f, indent=2)
        f.write(";")
    
    print(f"Successfully generated {output_file}")

if __name__ == "__main__":
    prepare_data(os.getcwd())
