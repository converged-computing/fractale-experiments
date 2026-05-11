import os
import re

# pip install simpleeval
from simpleeval import SimpleEval
from rich import print
import json
import yaml
import pydot
import subprocess
import hashlib
import graphviz
import tempfile
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path
import networkx as nx

with open("data.json", "r") as fd:
    repos = json.loads(fd.read())

RULE_BLOCK_RE = re.compile(
    r"^(rule|checkpoint)\s+(\w+):.*?(?=\n(?:rule|checkpoint|include|module)\s|\Z)",
    re.DOTALL | re.MULTILINE,
)
REPOS = [
    "https://github.com/" + x["full_name"]
    for x in repos
    if "wrappers" in x and x["wrappers"]
]
REPOS = ["https://github.com/" + x["full_name"] for x in repos]
DATA_DIR = Path("large-data")
DATA_DIR.mkdir(exist_ok=True)


def get_org_repo(url):
    parts = url.rstrip("/").split("/")
    return parts[-2], parts[-1]


def find_snakefile(path):
    search_paths = ["Snakefile", "workflow/Snakefile", "workflow/rules/common.smk"]
    for p in search_paths:
        full_path = Path(path) / p
        if full_path.exists():
            return full_path
    return None


def evaluate_expressions(lines, config):
    # Initialize the evaluator with your config dict
    s = SimpleEval(names={"config": config})
    results = []

    for line in lines:
        if "=" in line:
            # Split into key and expression, clean up whitespace/newlines
            key, expr = line.strip().split("=", 1)
            # Evaluate the expression safely
            try:
                results.append({key.strip(): s.eval(expr.strip())})
            except:
                results.append({key.strip(): expr.strip()})
        else:
            results.append(line)

    return results


def clean_dot_content(content):
    """
    Finds the start of the actual DOT graph and removes
    leading log messages or file paths.
    """
    import re

    # Look for the start of a digraph or graph (case insensitive)
    match = re.search(r"(strict\s+)?(digraph|graph)\b", content, re.IGNORECASE)
    if match:
        # Return everything from the match to the end of the file
        return content[match.start() :]
    return None


def get_file_hash(file_path):
    """
    Calculates the SHA-256 hash of a file's content.
    """
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        # Read in chunks to handle potentially large files
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()


def parse_rule_block(block):
    block = block.group(1).strip() if block else ""
    block = block.split(",") if block else []
    return [x for x in block if x.strip()]


def load_all_configs(repo_path):
    config_dir = Path(repo_path) / "config"
    assembled_config = {}

    # Check for both .yaml and .yml extensions
    for filepath in config_dir.glob("*.y*ml"):
        with open(filepath, "r") as f:
            try:
                data = yaml.safe_load(f)
                if data:
                    assembled_config.update(data)
            except:
                continue

    return assembled_config


def safe_lookup(expression, config_dict):
    """
    I'd rather not eval something.
    """
    # Matches 'config["..."]' or "config['...']"
    match = re.search(r'config\[["\'](.+?)["\']\]', expression)
    if match:
        key = match.group(1)
        return config_dict.get(key)
    return expression


def extract_rule_threads(config, block):
    threads = re.search(r"threads:\s*(.*)", block)

    threads = threads.group(1).strip() if threads else "1"
    if "config" in threads:
        threads = safe_lookup(threads, config)
    try:
        threads = int(threads)
    except:
        pass
    return threads


def extract_shapes_from_repo(repo_path, repo_url):
    """
    Cpture resources to get shapes.
    """
    # Rules in Snakemake are almost always top-level (no indentation)
    results = []

    # 1. Walk every file in the repo
    for root, _, files in os.walk(repo_path):
        for file in files:
            if file.endswith((".smk", ".snakefile")) or file == "Snakefile":
                file_path = Path(root) / file
                try:
                    content = file_path.read_text()
                except:
                    continue
                config = load_all_configs(repo_path)
                for match in RULE_BLOCK_RE.finditer(content):
                    block = match.group(0)
                    rule_id = block.split("\n")[0].split(" ")[1].strip(":").strip()
                    threads = extract_rule_threads(config, block)

                    # Capture the entire resources block
                    resources_raw = parse_rule_block(
                        re.search(
                            r"resources:\s*(.*?)(?=\n\s*\w+:|\Z)", block, re.DOTALL
                        )
                    )
                    resources = evaluate_expressions(resources_raw, config)

                    envs = []
                    software = {}
                    for environment in parse_rule_block(
                        re.search(r"conda:\s*(.*?)(?=\n\s*\w+:|\Z)", block, re.DOTALL)
                    ):
                        environment = environment.replace('"', "")
                        envs.append(environment)
                        path = os.path.join(
                            repo_path, "workflow", "envs", os.path.basename(environment)
                        )
                        if not os.path.exists(path) or not os.path.isfile(path):
                            continue
                        with open(path, "r") as file:
                            try:
                                software = yaml.safe_load(file)
                            except:
                                pass

                    try:
                        print(block)
                    except:
                        pass
                    print(f"  Threads: {threads}")
                    print(f"Resources: {resources}")
                    new_result = {
                        "block": block,
                        "rule_name": rule_id,
                        "file": str(file_path),
                        "threads": threads,
                        "resources_raw": resources_raw,
                        "resources": resources,
                        "software": software,
                        "repo": repo_url,
                    }
                    results.append(new_result)

    return results


def extract_resource_shapes():
    """
    Based on subset we can generate graph for, get software and resource spec.
    """
    skips = ["https://github.com/ccondon894/mpusilla_introner_project"]
    for i, repo_url in enumerate(REPOS):
        print(f"{i} of {len(REPOS)}")
        if repo_url in skips:
            continue
        org, repo = get_org_repo(repo_url)
        out_dir = DATA_DIR / org / repo
        out_dir.mkdir(parents=True, exist_ok=True)
        resource_path = os.path.join(str(out_dir), "resources.json")
        if os.path.exists(resource_path):
            continue

        with tempfile.TemporaryDirectory() as tmp_dir:
            print(f"--- Cloning {repo_url} ---")
            try:
                subprocess.run(
                    ["git", "clone", "--depth", "1", repo_url, tmp_dir],
                    check=True,
                    capture_output=True,
                )
            except:
                continue
            # this is resources and software
            shapes = extract_shapes_from_repo(tmp_dir, repo_url)

            # Save as we go, to be safe
            with open(resource_path, "w") as fd:
                fd.write(json.dumps(shapes, indent=2))

    # Step 2: Process data
    print("DONE REPOS")
    # workflow: an autonomus or semi autonomus orchestrationof task toward a larger goal for co,pletion of work.
    # TODO will also want to check for duplicates. how to weight?
    # TODO: add wrappers from their repository
    # TODO: parse for extensions to add to resources
    # TODO: parse repository metadata with GitHub API (text content in README and tags/description)
    # TODO: try to do grouping of the different repos based on tags AND extensions.
    # TODO storing blocks so we can add wrappers
    # TODO: look at transformation (order) of extensions
    # that might help an agent to say "ok, I have extension X what is this and what do I want to do next, what resources do I need?"
    import IPython

    IPython.embed()


def main():
    extract_resource_shapes()


if __name__ == "__main__":
    main()
