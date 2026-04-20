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


def index_files(root_dir):
    results = {}
    root_path = Path(root_dir)
    total_issues = {}

    # Find all result.json files
    for json_file in root_path.rglob("*-result.json"):
        try:
            with open(json_file, "r") as f:
                data = json.load(f)

            # Extract Path Info
            # Structure: root/experiment/org/repo/rest...
            relative_path = json_file.relative_to(root_path)
            experiment = relative_path.parts[0]
            if experiment.startswith('_'):
                continue
            parts = relative_path.parts

            experiment = parts[0]
            org = parts[1] if len(parts) > 1 else "unknown"
            repo = parts[2] if len(parts) > 2 else "unknown"
            filename = json_file.name.replace("-result.json", "")

            output = data["events"][-1]["data"]["outputs"]
            if "ERROR" in output and "SSL" in output:
                issues = []
                impl = None
                transformed_script = None
                errors = []
                summary = ""
                status = "SSL-ERROR"
            else:
                impl = output["implications"]
                issues = output["issues"]
                if "bash" in output['jobspec']:
                    transformed_script = utils.get_code_block(output["jobspec"], "bash")
                elif "sh" in output['jobspec']:
                    transformed_script = utils.get_code_block(output["jobspec"], "sh")
                else:
                    transformed_script = utils.extract_code_block(output['jobspec'])
                errors = output.get("errors") or []
                summary = output["summary"]
                status = "SUCCESS"

            original_script = (
                data.get("plan", {})
                .get("steps", [{}])[0]
                .get("inputs", {})
                .get("script", "N/A")
            )
            # metrics = data['metrics'][1]['data']
            # Break into components
            issues = [x.split(":", 1) for x in issues]

            if experiment not in results:
                results[experiment] = []
                total_issues[experiment] = {}

            for issue_name, issue in issues:
                if issue_name not in total_issues[experiment]:
                    total_issues[experiment][issue_name] = set()
                total_issues[experiment][issue_name].add(issue)

            results[experiment].append(
                {
                    "id": str(relative_path),
                    "experiment": experiment,
                    "org": org,
                    "repo": repo,
                    "status": status,
                    "filename": filename,
                    "issues": issues,
                    "implications": impl,
                    "errors": errors,
                    "summary": summary,
                    "original": original_script,
                    "transformed": transformed_script,
                }
            )
        except Exception as e:
            print(f"Error parsing {json_file}: {e}")
            import IPython

            IPython.embed()

    for experiment, issues in total_issues.items():
        for issue_type, items in issues.items():
            total_issues[experiment][issue_type] = list(items)

    outfile = os.path.join(here, "results", "issues.json")
    with open(outfile, "w") as f:
        json.dump(total_issues, f, indent=2)
    print(f"Indexed {len(results)} files into {outfile}")

    outfile = os.path.join(here, "results", "data.json")
    with open(outfile, "w") as f:
        json.dump(results, f, indent=2)
    print(f"Indexed {len(results)} files into {outfile}")


if __name__ == "__main__":
    index_files(os.path.join(here, "results", "convert"))
