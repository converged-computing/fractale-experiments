#!/usr/bin/env python3
import argparse
import hashlib
import json
import os
import re
import pydot
from collections import Counter
from pathlib import Path

import hdbscan
import networkx as nx
import numpy as np
import pandas
import pandas as pd
import umap
from sklearn.decomposition import NMF, TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer

DATA_DIR = Path("data")
DATA_DIR.mkdir(exist_ok=True)

STOPWORDS = [
    "rule",
    "input",
    "output",
    "shell",
    "params",
    "log",
    "config",
    "conda",
    "results",
    "threads",
    "sample",
    "logs",
    "envs",
    "yaml",
    "resources",
    "scripts",
    "txt",
    "dir",
    "py",
    "data",
    "script",
    "wildcards",
    "tsv",
    "path",
    "expand",
    "all",
    "lambda",
    "run",
    "for",
    "benchmark",
    "file",
    "out",
    "python",
    "in",
    "to",
    "rules",
    "join",
    "if",
    "temp",
    "index",
    "name",
    "samples",
    "files",
    "os",
    "yml",
    "id",
    "workflow",
    "else",
    "mkdir",
    "report",
    "directory",
    "read",
    "and",
    "outdir",
    "runtime",
    "message",
    "true",
    "with",
    "prefix",
    "echo",
    "from",
    "sorted",
    "env",
    "summary",
    "min",
    "html",
    "filtered",
    "type",
    "analysis",
    "the",
    "10",
    "time",
    "build",
    "base",
    "filter",
    "raw",
    "sort",
    "container",
    "set",
    "per",
    "list",
    "stats",
    "wrapper",
    "table",
    "db",
    "done",
    "of",
    "extra",
    "merge",
    "tmp",
    "format",
    "as",
    "str",
    "touch",
    "max",
    "sh",
    "rm",
    "pdf",
    "group",
    "json",
    "merged",
    "by",
    "print",
    "final",
    "counts",
    "map",
    "split",
    "size",
    "folder",
    "download",
    "model",
    "cat",
    "seq",
    "no",
    "count",
    "then",
    "fi",
    "create",
    "wc",
    "dirname",
    "awk",
    "make",
    "environment",
    "zip",
    "return",
    "bin",
    "length",
    "false",
    "cp",
    "view",
    "wildcard",
    "def",
    "default",
    "bash",
    "not",
    "is",
    "generate",
    "metadata",
    "tools",
    "info",
    "00",
    "constraints",
    "20",
    "on",
    "1000",
    "test",
    "mv",
    "int",
    "import",
    "src",
    "sed",
    "attempt",
    "open",
    "16",
    "len",
    "partition",
    "mode",
    "outputs",
    "names",
    "end",
    "cd",
    "category",
    "grep",
    "01",
    "12",
    "df",
    "clean",
    "version",
    "tmpdir",
    "use",
    "matrix",
    "idx",
    "num",
    "processed",
    "do",
    "cut",
    "check",
    "write",
    "project",
    "snakemake",
    "source",
    "using",
    "method",
    "tables",
    "add",
    "02",
    "database",
    "export",
    "wget",
    "total",
    "60",
    "100",
    "metrics",
    "gzip",
    "query",
    "vs",
    "30",
    "reports",
    "options",
    "or",
    "only",
    "combined",
    "https",
    "rst",
    "unit",
    "figures",
    "load",
    "provider",
    "38",
    "dict",
    "priority",
    "envmodules",
    "meta",
    "none",
    "opts",
    "result",
    "basename",
    "caption",
    "date",
    "header",
    "error",
    "this",
    "full",
    "prepare",
    "concat",
    "remove",
    "ids",
    "03",
    "50",
    "err",
    "paths",
    "unpack",
    "replace",
    "missing",
    "convert",
    "seed",
    "stdout",
    "pipefail",
    "loc",
    "module",
    "pipeline",
    "range",
    "batch",
    "perl",
    "processing",
    "inputs",
    "1024",
    "include",
    "values",
    "res",
    "aggregate",
    "annotated",
    "05",
    "calculate",
    "io",
    "url",
    "curl",
    "tab",
    "level",
    "10000",
    "control",
    "intermediate",
    "sm",
    "tee",
    "sep",
    "task",
    "tool",
    "labels",
    "15",
    "keep",
    "library",
    "datasets",
    "profile",
    "del",
    "process",
    "exit",
    "local",
    "parameters",
    "line",
    "depth",
    "code",
    "find",
    "04",
    "one",
    "pop",
    "24",
    "basedir",
    "root",
    "filtering",
    "dev",
    "columns",
    "openssl",
    "ext",
    "stderr",
    "checkpoint",
    "dist",
    "ca-certificates",
    "zcat",
    "models",
    "pre",
    "number",
    "copy",
    "ncurses",
    "suffix",
    "main",
    "year",
    "norm",
    "value",
    "flag",
    "subset",
    "release",
    "filename",
    "4000",
    "each",
    "sum",
    "2000",
    "running",
    "args",
    "runs",
    "label",
    "coord",
    "sub",
    "md",
    "into",
    "tk",
    "append",
    "unique",
    "command",
    "common",
    "rename",
    "be",
    "_libgcc_mutex",
    "complete",
    "window",
    "top",
    "libzlib",
    "at",
    "experiment",
    "readline",
    "that",
    "11",
    "64",
    "select",
    "setuptools",
    "parse",
    "keys",
    "are",
    "targets",
    "subject",
    "drop",
    "work",
    "32",
    "wheel",
    "allow",
    "images",
    "cache",
    "statistics",
    "head",
    "null",
    "image",
    "mean",
    "gunzip",
    "com",
    "key",
    "global",
    "lib",
    "pass",
    "scores",
    "smk",
    "elif",
    "19",
    "bench",
    "benchmark",
    "benchmarks",
    "bins",
    "logdir",
    "force",
    "profiles",
    "zlib",
    "gr",
    "org",
    "cmd",
    "other",
    "rev",
    "order",
    "nodes",
    "databases",
    "layout",
    "exec",
    "ghcr",
    "click",
    "pip",
    "llog",
    "docker",
    "singularity",
    "get",
    "params",
    "args",
    "benchmark",
    "gz",
]

SHELL_PLUMBING = [
    "mkdir", "cd", "rm", "cp", "mv", "echo", "touch", "exit", "true", "false", 
    "pipefail", "set", "export", "grep", "sed", "awk", "tee", "dev", "null", 
    "stdout", "stderr", "bin", "bash", "python", "import", "from", "as",
    "java_opts", "extra", "prefix", "suffix", "basename", "dirname",
    "tmp", "temp", "tmpdir", "outdir", "dir", "path", "workdir"
]

# Add these to your existing STOPWORDS list
STOPWORDS.extend(SHELL_PLUMBING)



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


def export_to_json(df, signatures, motif_counts, filename="workflow_data.json"):
    # Get counts per phenotype
    counts = df["phenotype_id"].value_counts().to_dict()

    nodes = []
    # Filter out noise label -1 if it exists
    unique_ids = [i for i in df["phenotype_id"].unique() if i != -1]

    for p_id in sorted(unique_ids):
        nodes.append(
            {
                "id": int(p_id),
                "label": f"Phenotype {p_id}",
                "size": int(counts.get(p_id, 0)),
                "tokens": signatures.get(p_id, []),
            }
        )

    links = []
    for _, row in motif_counts.iterrows():
        # D3 expects 'source' and 'target' to match node IDs
        links.append(
            {
                "source": int(row["source_pheno"]),
                "target": int(row["target_pheno"]),
                "weight": int(row["frequency"]),
            }
        )

    output = {"nodes": nodes, "links": links}
    with open(filename, "w") as f:
        json.dump(output, f, indent=4)
    print(f"Data exported to {filename}")


def normalize_software(software_dict):
    if not software_dict or "dependencies" not in software_dict:
        return set()
    deps = software_dict.get("dependencies") or []
    normalized = set()
    for d in deps:
        if not isinstance(d, str):
            continue
        # Strip versions, channels, and bioconductor prefixes
        name = re.split("[=> <]", d)[0].strip()
        if "::" in name:
            name = name.split("::")[-1]
        name = name.replace("bioconductor-", "").replace("r-", "")

        if name and name.lower() not in STOPWORDS:
            normalized.add(name.lower())
    return normalized


def parse_snakemake_rule(rule_block):
    """
    Parses a single Snakemake rule block into a structured dictionary.
    """
    lines = rule_block.splitlines()
    rule_data = {"name": None, "docstring": None, "directives": {}}
    # Rule name
    rule_match = re.search(r"rule\s+(\w+):", lines[0])
    if rule_match:
        rule_data["name"] = rule_match.group(1)

    current_directive = None
    directive_content = []

    # Find the first indentation level inside the rule
    # Most Snakefiles use 4 spaces or 1 tab.
    for line in lines[1:]:
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        # Check for docstring
        if '"""' in stripped and not current_directive:
            doc_match = re.search(r'"""(.*?)"""', rule_block, re.DOTALL)
            if doc_match:
                rule_data["docstring"] = doc_match.group(1).strip()
            continue

        # Detect the start of a new directive (e.g., "input:", "wrapper:")
        # Directives are typically 'keyword:' at the start of a line (plus indent)
        directive_match = re.match(r"^\s+(\w+):(.*)", line)

        if directive_match:
            # Save previous directive
            if current_directive:
                rule_data["directives"][current_directive] = " ".join(
                    directive_content
                ).strip()

            current_directive = directive_match.group(1)
            initial_content = directive_match.group(2).strip()
            directive_content = [initial_content] if initial_content else []
        elif current_directive:
            # Continue collecting content for the current directive
            directive_content.append(stripped)

    # Save the last one
    if current_directive:
        rule_data["directives"][current_directive] = " ".join(directive_content).strip()

    return rule_data


def get_phenotype_signatures(vectorizer, svd, cluster_data, labels, top_n=10):
    tokens = vectorizer.get_feature_names_out()
    signatures = {}

    unique_labels = set(labels)
    if -1 in unique_labels:
        unique_labels.remove(-1)

    for label in unique_labels:
        # Get all rules belonging to this cluster
        member_indices = np.where(labels == label)[0]
        # Calculate the "centroid" of this cluster in the 50D SVD space
        centroid_50d = cluster_data[member_indices].mean(axis=0)
        # Project that centroid back to the original thousands of tokens
        token_weights = svd.inverse_transform(centroid_50d.reshape(1, -1))
        # Get top tokens
        top_indices = token_weights.argsort()[0][-top_n:][::-1]
        signatures[int(label)] = [tokens[i] for i in top_indices]

    return signatures


def write_csv(filename, fieldnames, data_rows):
    with open(filename, "w") as f:
        f.write(",".join(fieldnames) + "\n")
        for row in data_rows:
            line = [str(row.get(fn, 0)) for fn in fieldnames]
            f.write(",".join(line) + "\n")


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


def build_phenotype_motifs(pheno_lookup, signatures, phenotype_counts):
    """
    Args:
        pheno_lookup: Dict mapping { "rule_label": phenotype_id }
        signatures: Dict mapping { phenotype_id: [top_tokens] }
    Returns:
        motif_data: Dict for D3.js visualization
    """
    # G_pheno stores relationships between Phenotype IDs
    G_pheno = nx.DiGraph()
    dot_files = list(Path(DATA_DIR).glob("**/dag.txt"))
    seen_hashes = set()

    print(f"Analyzing {len(dot_files)} DAGs for semantic motifs...")

    for dot_path in dot_files:
        file_hash = get_file_hash(dot_path)
        if file_hash in seen_hashes:
            continue
        seen_hashes.add(file_hash)

        with open(dot_path, "r", encoding="utf-8", errors="ignore") as f:
            raw_content = f.read()

        cleaned_content = clean_dot_content(raw_content)
        if not cleaned_content:
            continue

        try:
            # Parse the DOT DAG
            graphs = pydot.graph_from_dot_data(cleaned_content)
            if not graphs:
                continue
            graph = graphs[0]

            # 1. Map Node ID (DOT) -> Phenotype ID
            node_to_pheno = {}
            for node in graph.get_nodes():
                node_id = node.get_name().strip('"')
                label = (
                    node.get_attributes()
                    .get("label", "")
                    .replace('"', "")
                    .split("\\n")[0]
                    .strip()
                )

                # Use our discovered phenotype if available
                p_id = pheno_lookup.get(label)
                if p_id is not None:
                    node_to_pheno[node_id] = p_id

            # 2. Add Transitions to the Phenotype Graph
            for edge in graph.get_edges():
                src_id = edge.get_source().strip('"')
                dst_id = edge.get_destination().strip('"')

                src_p = node_to_pheno.get(src_id)
                dst_p = node_to_pheno.get(dst_id)

                # We only care about transitions between phenotypes
                if src_p is not None and dst_p is not None:
                    if G_pheno.has_edge(src_p, dst_p):
                        G_pheno[src_p][dst_p]["weight"] += 1
                    else:
                        G_pheno.add_edge(src_p, dst_p, weight=1)
        except Exception as e:
            print(f"Skipping {dot_path} due to parse error: {e}")

    # Calculate node sizes based on how many rules are in each phenotype
    # node_sizes = df['phenotype_id'].value_counts().to_dict()

    unique_transitions = G_pheno.number_of_edges()

    # The total number of connections observed across all 128 files
    total_observations = sum(d["weight"] for u, v, d in G_pheno.edges(data=True))

    print(f"Discovered {unique_transitions} unique scientific motifs.")
    print(f"Based on {total_observations} total observed transitions in the 128 DAGs.")

    nodes_json = []
    for p_id in G_pheno.nodes():
        nodes_json.append(
            {
                "id": int(p_id),
                "label": f"Phenotype {p_id}",
                "tokens": signatures.get(p_id, []),
                "size": int(phenotype_counts.get(p_id, 0)),
            }
        )

    links_json = []
    for u, v, d in G_pheno.edges(data=True):
        links_json.append(
            {"source": int(u), "target": int(v), "weight": int(d["weight"])}
        )

    motif_data = {"nodes": nodes_json, "links": links_json}

    with open("web/workflow-motifs/workflow_data.json", "w") as f:
        json.dump(motif_data, f, indent=4)

    print(f"Motif Discovery Complete. Exported {len(links_json)} transitions.")
    return motif_data


def block_tokenizer(text):
    """
    A tokenizer specifically for Snakemake/Python code.
    Splits on syntax, but preserves meaningful scientific tokens.
    """
    # 1. Remove comments to reduce noise
    text = re.sub(r"#.*", "", text)

    # 2. Split on non-word characters (including dots, slashes, and brackets)
    # But we keep underscores and hyphens for now
    raw_tokens = re.split(r"[^a-zA-Z0-9_\-]+", text)

    final_tokens = []
    for token in raw_tokens:
        # Split snake_case and CamelCase
        # e.g., 'build_powerplants' -> ['build', 'powerplants']
        # e.g., 'GmapMapping' -> ['Gmap', 'Mapping']
        sub_tokens = re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?=[A-Z][a-z]|\b)|[0-9]+", token)

        for st in sub_tokens:
            st = st.lower()
            if len(st) > 1:  # Ignore single chars
                final_tokens.append(st)

    return set(final_tokens)


def main():
    parser = argparse.ArgumentParser(description="Workflow Resource Analyzer")
    parser.add_argument("--root", help="Root directory for discovery", default="data")
    parser.add_argument("--outdir", help="Output directory", default="web/resources")
    args = parser.parse_args()

    if not os.path.exists(args.outdir):
        os.makedirs(args.outdir)

    all_data = []
    for root, _, files in os.walk(args.root):
        if "resources.json" in files:
            rel_path = os.path.relpath(root, args.root)
            repo_name = rel_path.split(os.sep)[0] if rel_path != "." else "root"
            with open(os.path.join(root, "resources.json"), "r") as f:
                batch = json.load(f)
                for entry in batch:
                    entry["repo_name"] = repo_name
                all_data.extend(batch)

    if not all_data:
        print("No data found.")
        return

    unique_rules = {}
    unique_software = {}

    # Token rows for tfidf
    rows = []

    resource_counter = Counter()
    wrappers_repos = Counter()
    software_df = pandas.DataFrame(columns=["rule", "software", "file", "repo"])
    sidx = 0
    df = pandas.DataFrame(columns=["rule", "resource", "value", "file", "repo"])
    idx = 0
    for i, entry in enumerate(all_data):
        print(f"{i} of {len(all_data)}", end="\r")
        name = entry["rule_name"]
        repo = entry["repo_name"]
        sw_set = normalize_software(entry.get("software", {}))

        # If we have a wrapper, add the software from it
        block = entry["block"]
        rule = parse_snakemake_rule(block)
        tokens = block_tokenizer(block)

        # Get extensions and commands
        # Since software is spread across steps, it isn't a great source of truth.

        if "resources" in rule["directives"]:
            res_list = rule["directives"]["resources"].split(",")
            for item in res_list:
                if item.strip().startswith("#") or " " in item:
                    continue
                if "=" not in item:
                    continue
                k, v = item.split("=", 1)
                resource_counter[k.strip()] += 1
                v = v.replace('"', "").replace("'", "")
                if "lambda" in item or "config" in item:
                    continue
                df.loc[idx, :] = [name, k.strip(), v, entry["file"], repo]
                idx += 1

        wrapper = None
        if "wrapper" in entry["block"] and "wrapper" in rule["directives"]:
            raw_wrapper = (
                rule["directives"]["wrapper"].strip("\"' ").split("#")[0].split(" ")[0]
            )
            parts = raw_wrapper.split("/")
            roots = {"bio", "geo", "phys", "utils", "meta"}
            for i, p in enumerate(parts):
                if p in roots:
                    wrapper = "/".join(parts[i:])
                    wrappers_repos[wrapper] += 1
                    break

        # Add the wrapper as software
        if wrapper is not None:
            sw_set.add(wrapper)

        # Viz Data (Aggregate by name)
        if sw_set:
            software_df.loc[sidx, :] = [
                name,
                ",".join(list(sw_set)),
                entry["file"],
                repo,
            ]
            sidx += 1

            if name not in unique_rules:
                unique_rules[name] = {
                    "id": name,
                    "label": name,
                    "type": "rule",
                    "sw": set(),
                }
            # Combine software from all repos for this rule name
            unique_rules[name]["sw"].update(sw_set)

            for s in sw_set:
                # Add tokens to software
                tokens.add(s)
                if s not in unique_software:
                    unique_software[s] = {"id": s, "label": s, "type": "software"}

        rows.append(
            {
                "rule_id": name,
                "repo": repo,
                "tokens": list(tokens),
                "token_count": len(tokens),
            }
        )

    viz_nodes = []
    viz_links = []

    # Build unique nodes and links
    for name, rdata in unique_rules.items():
        for s in rdata["sw"]:
            viz_links.append({"source": name, "target": s})

        node_copy = rdata.copy()
        del node_copy["sw"]  # Remove set before JSON dump
        viz_nodes.append(node_copy)

    viz_nodes.extend(unique_software.values())
    with open("graph/wrappers_count.json", "w") as f:
        json.dump(dict(wrappers_repos), f, indent=2)

    # TFIDF for identities
    df = pd.DataFrame(rows)

    # TF-IDF doesn't need to re-tokenize if we give it the pre-processed list
    def identity_tokenizer(text):
        return text

    df["unique_tokens"] = df["tokens"].apply(lambda x: list(set(x)))
    df["complexity_score"] = df["tokens"].apply(len)

    # Filter out stopwords ourseilves
    filtered = []
    for tokenset in df.unique_tokens.tolist():
        filtered.append([x for x in tokenset if x not in STOPWORDS])
    df["filtered"] = filtered

    vectorizer = TfidfVectorizer(
        tokenizer=identity_tokenizer,
        preprocessor=identity_tokenizer,
        token_pattern=None,
        stop_words=None,
        sublinear_tf=True,
        min_df=2,
    )

    # 1. Compress to 50 dimensions
    svd = TruncatedSVD(n_components=50)
    tfidf_matrix = vectorizer.fit_transform(df["filtered"])
    compressed_vectors = svd.fit_transform(tfidf_matrix)

    # 2. Project to 2D for plotting
    # reducer = umap.UMAP()
    # embedding_2d = reducer.fit_transform(compressed_vectors)

    # 1. More granular clustering
    # Lowering min_cluster_size will split the giant "Phenotype 7" into specific tools
    clusterer = hdbscan.HDBSCAN(
        min_cluster_size=5,  # smaller clusters = more specific software stacks
        min_samples=1,  # less aggressive noise reduction
        gen_min_span_tree=True,
    )
    df["phenotype_id"] = clusterer.fit_predict(compressed_vectors)

    # 2. Create the lookup dictionary BEFORE building motifs
    pheno_lookup = df.set_index("rule_id")["phenotype_id"].to_dict()

    # 3. Get the signatures
    signatures = get_phenotype_signatures(
        vectorizer, svd, compressed_vectors, df["phenotype_id"].values
    )

    # 4. Build Motifs (This generates the links based on the DAG files)
    phenotype_counts = df["phenotype_id"].value_counts().to_dict()
    motif_data = build_phenotype_motifs(pheno_lookup, signatures, phenotype_counts)

    # Analyzing 128 DAGs for semantic motifs...
    # Discovered 316 unique scientific motifs.
    # Based on 6700 total observed transitions in the 128 DAGs.

    # 5. Export with semantic names
    # export_to_json(df, signatures, motif_data, "workflow_data.json")
    # plt.figure(figsize=(12, 8))
    # scatter = plt.scatter(
    #    embedding_2d[:, 0],
    #    embedding_2d[:, 1],
    #    c=df['phenotype_id'],
    #    cmap='turbo',
    #    s=2,
    #    alpha=0.5
    # )
    # plt.colorbar(scatter, label='Phenotype ID')
    # plt.title("UMAP Projection of Snakemake Rule Phenotypes")
    # plt.show()

    import IPython

    IPython.embed()

    # export_to_json(df, signatures, top_motifs)


if __name__ == "__main__":
    main()
