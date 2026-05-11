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
DATA_DIR = Path("data")
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


def extract_dag(repo_url):
    """
    Use snakemake to extract the DAG. This will form our ground truth
    and basis for asking the agent to perform tasks.
    """
    org, repo = get_org_repo(repo_url)
    out_dir = DATA_DIR / org / repo
    out_dir.mkdir(parents=True, exist_ok=True)

    # Changed to text. Too lazy to rename variable.
    json_path = out_dir / "dag.txt"

    if json_path.exists():
        print(f"Skipping {org}/{repo}: Already processed.")
        return

    with tempfile.TemporaryDirectory() as tmp_dir:
        print(f"--- Cloning {org}/{repo} ---")
        try:
            subprocess.run(
                ["git", "clone", "--depth", "1", repo_url, tmp_dir],
                check=True,
                capture_output=True,
            )

            snakefile = find_snakefile(tmp_dir)
            if not snakefile:
                print(f"Skipping: No Snakefile found in {repo}")
                return

            print(f"Generating DAG for {repo}...")
            success = True
            for test_path in ["test", "tests", "tests", ".test"]:
                cwd = os.path.join(tmp_dir, test_path)

                # We use --forceall to ensure we get as much of the graph as possible
                # even without data files present. I am using .test because it is
                # generally testing and more chance to reproduce.
                if not os.path.exists(cwd):
                    continue
                print(f"Testing {cwd}")
                result = subprocess.run(
                    ["snakemake", "--dag", "--snakefile", str(snakefile), "--forceall"],
                    cwd=cwd,
                    capture_output=True,
                    text=True,
                )

                if result.returncode == 0:
                    print("Successful result!")
                    print(result.stdout)
                    with open(json_path, "w") as f:
                        f.write(result.stdout)

                    png_path = os.path.join(out_dir, "dag")
                    graphviz.Source.from_file(json_path).render(
                        png_path, format="png", cleanup=True
                    )
                    delete_path = os.path.join(out_dir, "dag.json")
                    if os.path.exists(delete_path):
                        os.remove(delete_path)
                    success = True
                    break

            if not success:
                # Some workflows fail to parse without a config file.
                # We save the error for debugging.
                print(f"Error generating DAG for {repo}")

        except Exception as e:
            print(f"Failed to process {repo}: {e}")



def evaluate_expressions(lines, config):
    # Initialize the evaluator with your config dict
    s = SimpleEval(names={'config': config})
    results = []

    for line in lines:
        if '=' in line:
            # Split into key and expression, clean up whitespace/newlines
            key, expr = line.strip().split('=', 1)
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


def build_relationship_matrix():
    G_global = nx.DiGraph()
    dot_files = list(Path(DATA_DIR).glob("**/dag.txt"))
    seen = set()
    print(f"Found {len(dot_files)} DAG files. Starting parse...")
    count = 0
    issues = []

    print("\n--- Aggregating Relationships ---")
    for dot_path in dot_files:
        file_hash = get_file_hash(dot_path)
        if file_hash in seen:
            continue
        seen.add(file_hash)

        with open(dot_path, "r", encoding="utf-8", errors="ignore") as f:
            raw_content = f.read()
        cleaned_content = clean_dot_content(raw_content)
        if not raw_content or not cleaned_content:
            issues.append(raw_content)
            continue

        graph = pydot.graph_from_dot_data(cleaned_content)[0]
        node_to_wrapper = {}
        for node in graph.get_nodes():
            node_id = node.get_name().strip('"')
            attrs = node.get_attributes()
            label = attrs.get("label", "")
            label = label.replace('"', "").split("\\n")[0].strip()
            node_to_wrapper[node_id] = label

        for edge in graph.get_edges():
            src = edge.get_source().strip('"')
            dst = edge.get_destination().strip('"')
            src_w = node_to_wrapper.get(src)
            dst_w = node_to_wrapper.get(dst)

            if src_w and dst_w:
                if G_global.has_edge(src_w, dst_w):
                    G_global[src_w][dst_w]["weight"] += 1
                else:
                    G_global.add_edge(src_w, dst_w, weight=1)
        # Number of unique we are actually adding
        count += 1

    # Metrics: started with 128 dag.txt
    #          had 71 not duplicated, read plots
    #          3 could not parse with snakemake
    #          so a total of 74 contenders (seen unique)
    print(f"Processing Complete.")

    # Convert to Matrix (this is 741 nodes)
    if len(G_global.nodes) == 0:
        return None
    matrix = nx.to_pandas_adjacency(G_global, weight="weight")
    return matrix.sort_index(axis=0).sort_index(axis=1)


def plot_matrix(matrix):

    # Filtered
    min_connections = 2
    filtered_matrix = matrix.loc[
        matrix.sum(axis=1) >= min_connections, matrix.sum(axis=0) >= min_connections
    ]

    # Use a log scale or binary if counts are low to see patterns better
    sns.clustermap(
        filtered_matrix,
        cmap="YlOrRd",
        standard_scale=1,  # Normalizes the colors to make sparse connections visible
        figsize=(20, 20),
        cbar_kws={"label": "Connection Strength"},
    )
    plt.savefig("clustered_gr_2_connections.png")

    plt.title("Snakemake Step Matrix")
    plt.xlabel("Target (Consumes Input)")
    plt.ylabel("Source (Produces Output)")
    plt.xticks(rotation=90, fontsize=8)
    plt.yticks(fontsize=8)
    plt.tight_layout()
    plt.savefig("web/wrapper_handshake_matrix.png", dpi=300)
    print("Matrix saved to wrapper_handshake_matrix.png")

    all_tools = sorted(list(set(matrix.index) | set(matrix.columns)))

    square_matrix = matrix.reindex(index=all_tools, columns=all_tools, fill_value=0)
    G = nx.from_pandas_adjacency(square_matrix, create_using=nx.DiGraph)
    G.remove_edges_from(
        [(u, v) for u, v, d in G.edges(data=True) if d.get("weight", 0) == 0]
    )

    threshold = 1
    G_filtered = G.copy()
    G_filtered.remove_edges_from(
        [(u, v) for u, v, d in G.edges(data=True) if d.get("weight", 0) <= threshold]
    )
    G_filtered.remove_nodes_from(list(nx.isolates(G_filtered)))

    plt.figure(figsize=(15, 12))
    pos = nx.spring_layout(
        G_filtered, k=0.5, iterations=50
    )  # k adjusts distance between nodes

    nx.draw_networkx_nodes(
        G_filtered, pos, node_size=50, node_color="skyblue", alpha=0.7
    )

    weights = [G_filtered[u][v]["weight"] for u, v in G_filtered.edges()]
    max_w = max(weights) if weights else 1
    edge_widths = [(w / max_w) * 5 for w in weights]

    nx.draw_networkx_edges(
        G_filtered, pos, width=edge_widths, edge_color="gray", arrowsize=10, alpha=0.5
    )
    top_nodes = [n for n, d in G_filtered.degree() if d > 1]
    labels = {
        n: n.split("/")[-1] for n in top_nodes
    }  # Shorten name to the tool name only
    nx.draw_networkx_labels(G_filtered, pos, labels=labels, font_size=8)

    plt.title(f"Bioinformatics Tool Highways (Connections > {threshold})")
    plt.axis("off")

    edge_list = nx.to_pandas_edgelist(G_filtered)
    edge_list.to_csv("tool_handshakes_filtered.csv", index=False)
    d3_data = nx.node_link_data(G)

    # Add some extra metadata for the visualization
    for node in d3_data["nodes"]:
        # Group by the first part of the wrapper name (e.g., 'bio', 'utils')
        node["group"] = node["id"].split("/")[0] if "/" in node["id"] else "rule"

    d3_data = {
        "nodes": [
            {"id": n, "group": n.split("/")[0] if "/" in n else "rule"}
            for n in G.nodes()
        ],
        "links": [
            {"source": u, "target": v, "weight": d.get("weight", 1)}
            for u, v, d in G.edges(data=True)
        ],
    }

    # This is to visualize
    with open("web/graph_data.json", "w") as f:
        json.dump(d3_data, f, indent=2)

    # Final step! Save important connections for agent.
    pairs = {}
    for node in G.nodes():
        # Get outgoing connections, sorted by weight (popularity)
        successors = []
        for successor in G.successors(node):
            weight = G[node][successor]["weight"]
            successors.append({"tool": successor, "support": int(weight)})

        successors = sorted(successors, key=lambda x: x["support"], reverse=True)
        pairs[node] = {
            "description": f"Snakemake wrapper for {node.split('/')[-1]}",
            "recommended_next_steps": successors,
        }

    with open("step-pairs.json", "w") as f:
        json.dump(pairs, f, indent=2)


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
            data = yaml.safe_load(f)
            if data:
                assembled_config.update(data)

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


def extract_shapes_from_repo(repo_path):
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
                content = file_path.read_text()
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
                    for environment in parse_rule_block(re.search(r"conda:\s*(.*?)(?=\n\s*\w+:|\Z)", block, re.DOTALL)):
                        environment = environment.replace('"', '')
                        envs.append(environment)
                        path = os.path.join(
                            repo_path, "workflow", "envs", os.path.basename(environment)
                        )
                        if not os.path.exists(path) or not os.path.isfile(path):
                            continue
                        with open(path, "r") as file:
                            software = yaml.safe_load(file)

                    print(block)
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
                    }
                    results.append(new_result)

    return results


def visualize_and_save(matrix):
    matrix.to_csv("unique_wrapper_relationships.csv")
    plt.figure(figsize=(22, 16))
    sns.heatmap(
        matrix,
        annot=False,
        cmap="YlGnBu",
        cbar_kws={"label": "Count in Unique Workflows"},
    )

    plt.title("Master Transition Matrix (Unique Workflows Only)", fontsize=18)
    plt.xlabel("Target Wrapper", fontsize=12)
    plt.ylabel("Source Wrapper", fontsize=12)
    plt.xticks(rotation=90, fontsize=7)
    plt.yticks(fontsize=7)
    plt.tight_layout()
    # This picture is not really useful - I made the d3 instead.
    plt.savefig("web/unique_wrapper_matrix.png", dpi=300)


def extract_resource_shapes():
    """
    Based on subset we can generate graph for, get software and resource spec.
    """
    dot_files = list(Path(DATA_DIR).glob("**/dag.txt"))
    seen = set()
    for dot_file in dot_files:
        file_hash = get_file_hash(dot_file)
        resource_path = os.path.join(os.path.dirname(dot_file), "resources.json")
        if file_hash in seen:
            if os.path.exists(resource_path):
                os.remove(resource_path)
            continue
        seen.add(file_hash)

        repo_path = "https://github.com/" + "/".join(dot_file.parts[-3:-1])
        with tempfile.TemporaryDirectory() as tmp_dir:
            print(f"--- Cloning {repo_path} ---")
            subprocess.run(
                ["git", "clone", "--depth", "1", repo_path, tmp_dir],
                check=True,
                capture_output=True,
            )
            # this is resources and software
            shapes = extract_shapes_from_repo(tmp_dir)

            # Save as we go, to be safe
            with open(resource_path, "w") as fd:
                fd.write(json.dumps(shapes, indent=2))


def main():
    # for repo_url in REPOS:
    #    extract_dag(repo_url)
    matrix = build_relationship_matrix()
    # extract_resource_shapes()

    # Step 2: Process data
    print("DONE REPOS")
    # TODO will also want to check for duplicates. how to weight?
    import IPython

    IPython.embed()

    visualize_and_save(matrix)
    plot_matrix(matrix)
    print(f"Processed {len(matrix)} unique wrapper relationships.")


if __name__ == "__main__":
    main()
