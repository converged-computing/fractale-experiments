import os
import json
import re


def bundle_directory():
    # Look for folders like 'lammps', 'amg2023', etc.
    apps = [d for d in os.listdir(".") if os.path.isdir(d) and not d.startswith(".")]

    agent_data = {}

    for app in apps:
        agent_data[app] = {}
        for filename in os.listdir(app):
            if not filename.endswith(".json"):
                continue

            # Parse run ID and type (events vs metrics)
            match = re.match(r"^(.*?)-(events|metrics)\.json$", filename)
            if match:
                run_id = match.group(1)
                file_type = match.group(2)

                if run_id not in agent_data[app]:
                    agent_data[app][run_id] = {"events": [], "metrics": []}

                filepath = os.path.join(app, filename)
                with open(filepath, "r", encoding="utf-8") as f:
                    try:
                        data = json.load(f)
                        # Normalize structure
                        if file_type == "events":
                            agent_data[app][run_id]["events"] = (
                                data
                                if isinstance(data, list)
                                else data.get("events", [])
                            )
                            if isinstance(data, dict) and "machine" in data:
                                agent_data[app][run_id]["machine"] = data["machine"]
                        elif file_type == "metrics":
                            agent_data[app][run_id]["metrics"] = (
                                data if isinstance(data, list) else []
                            )
                    except Exception as e:
                        print(f"Error parsing {filepath}: {e}")

    # Write out as a JavaScript variable
    with open("data.js", "w", encoding="utf-8") as f:
        f.write("const AGENT_DATA = ")
        json.dump(agent_data, f, separators=(",", ":"))
        f.write(";\n")

    print(f"Successfully bundled data into data.js")


if __name__ == "__main__":
    bundle_directory()
