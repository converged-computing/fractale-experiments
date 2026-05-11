import os
import yaml
import json
import subprocess
import tempfile
import re
from pathlib import Path

def index_wrappers():
    repo_url = "https://github.com/snakemake/snakemake-wrappers"
    results = {}

    with tempfile.TemporaryDirectory() as tmp_dir:
        print(f"Cloning {repo_url} to temporary directory...")
        # Shallow clone to save time/bandwidth
        subprocess.run(
            ["git", "clone", "--depth", "1", repo_url, tmp_dir], 
            check=True, capture_output=True
        )

        roots = ['meta/bio', 'bio', 'geo', 'phys/root', 'utils']
        for root in roots:
            wrapper_root = os.path.join(tmp_dir, root)
            dirs = os.listdir(wrapper_root)
            for dirname in dirs:
                wrapper_dir = os.path.join(wrapper_root, dirname)
                wrapper_name = wrapper_dir.replace(tmp_dir, '').strip(os.sep)
                files = os.listdir(wrapper_dir)
                meta = {}
                if "meta.yaml" in files:                
                    with open(os.path.join(wrapper_dir, "meta.yaml"), 'r') as f:
                        meta = yaml.safe_load(f) or {}

                software = {}
                software_path = os.path.join(wrapper_dir, "environment.yaml")
                if os.path.exists(software_path):
                    with open(software_path, 'r') as f:
                        software = yaml.safe_load(f)

                script_file = None
                for s in ["wrapper.py", "script.py", "wrapper.R", "script.R"]:
                     if os.path.exists(os.path.join(wrapper_dir, s)):
                         script_file = s
                         break

                results[wrapper_name] = {
                    "name": wrapper_name,
                    "domain": wrapper_name.split('/')[0] if '/' in wrapper_name else "unknown",
                    "software": software,
                    "meta": meta,
                    "script_type": script_file,
                    "has_test": os.path.exists(os.path.join(wrapper_dir, "test"))
                }

    return results

if __name__ == "__main__":
    wrapper_data = index_wrappers()
    
    output_file = "wrappers.json"
    with open(output_file, "w") as f:
        json.dump(wrapper_data, f, indent=2)
    
    print(f"Successfully indexed {len(wrapper_data)} wrappers with version data.")
