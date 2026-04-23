import os
import json
from pathlib import Path
import resource_secretary.utils as utils

here = os.path.dirname(os.path.abspath(__file__))


def parse_issue(issue_str):
    if ":" in issue_str:
        category, reason = issue_str.split(":", 1)
        return category.strip(), reason.strip()
    return "UNKNOWN", issue_str


def extract(root_dir):
    root_path = Path(root_dir)

    # Find all result.json files
    for json_file in root_path.rglob("*-result.json"):
        try:
            with open(json_file, "r") as f:
                data = json.load(f)
        except:
            continue

        # Extract Path Info
        # Structure: root/experiment/org/repo/rest...
        relative_path = json_file.relative_to(root_path)
        experiment = relative_path.parts[0]
        if experiment.startswith("_"):
            continue
        parts = relative_path.parts

        experiment = parts[0]
        # We don't need singularity anymore!
        if "singularity" in experiment or "v1" in experiment:
            continue
        filename = json_file.name.replace("-result.json", "")
        output = data["events"][-1]["data"]["outputs"]
        if "ERROR" in output and "SSL" in output:
            continue

        if "bash" in output["jobspec"]:
            transformed_script = utils.get_code_block(output["jobspec"], "bash")
        elif "sh" in output["jobspec"]:
            transformed_script = utils.get_code_block(output["jobspec"], "sh")
        else:
            transformed_script = utils.extract_code_block(output["jobspec"])

        filename = filename.replace('flux-to-slurm-', '')
        outfile = os.path.join(here, "sbatch", f"{experiment}-{filename}.sbatch")
        with open(outfile, "w") as f:
            f.write(transformed_script)
        print(f"Wrote {outfile} to file.")


if __name__ == "__main__":
    extract(os.path.join(here, "results", "convert"))
