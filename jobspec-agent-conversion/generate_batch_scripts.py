import os
import json
from pathlib import Path

here = os.path.dirname(os.path.abspath(__file__))


def parse_issue(issue_str):
    if ":" in issue_str:
        category, reason = issue_str.split(":", 1)
        return category.strip(), reason.strip()
    return "UNKNOWN", issue_str


def index_files(root_dir, dirname):
    root_path = Path(root_dir)

    # Find all result.json files
    for i, json_file in enumerate(root_path.rglob("*-result.json")):
        with open(json_file, "r") as f:
            data = json.load(f)

        # Extract Path Info
        # Structure: root/experiment/org/repo/rest...
        relative_path = json_file.relative_to(root_path)
        experiment = relative_path.parts[0]
        if experiment.startswith("_"):
            continue
        parts = relative_path.parts
        experiment = parts[0]

        output = data["events"][-1]["data"]["outputs"]
        if "ERROR" in output and "SSL" in output:
            continue
        transformed_script = output["jobspec"]
        if transformed_script:
            result_dir = os.path.join(here, "results", "batch", dirname)
            if not os.path.exists(result_dir):
                os.makedirs(result_dir)
            result_path = os.path.join(result_dir, f"{i}.sh")
            with open(result_path, "w") as fd:
                fd.write(transformed_script)


if __name__ == "__main__":
    for dirname in ["base", "1k", "details"]:
        index_files(os.path.join(here, "results", dirname), dirname)
