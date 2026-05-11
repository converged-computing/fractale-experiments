#!/usr/bin/env python3

import numpy as np
import argparse
import fnmatch
import hashlib
import os
import statistics
import shutil
import sys
import sqlite3
import subprocess
import json
import seaborn as sns
import matplotlib.pylab as plt

from io import StringIO
import csv

here = os.path.abspath(os.path.dirname(__file__))
root = os.path.dirname(here)

def remove_upper_outliers(data):
    """
    Remove upper outliers
    """
    bound = np.percentile(data, [95])
    return [x for x in data if x < bound[0]]


def get_parser():
    parser = argparse.ArgumentParser(description="Cyclomatic Complexity Calculator")
    parser.add_argument(
        "--input",
        help="Input json listing (file)",
        default=os.path.join(root, "sample-1k.json"),
    )
    parser.add_argument(
        "--outdir",
        help="Output directory",
        default=os.path.join(root, "img"),
    )
    return parser


def content_hash(filename, algorithm="sha256"):
    with open(filename, "rb", buffering=0) as f:
        return hashlib.file_digest(f, algorithm).hexdigest()


def recursive_find(base, pattern="*"):
    for root, _, filenames in os.walk(base):
        for filename in fnmatch.filter(filenames, pattern):
            yield os.path.join(root, filename)


def calculate_complexity(filepath):
    """
    Use shellmetrics to calculate complexity.

    This returns one line per complexity. We are going to return an
    average across functions for one value, but note we could get partial
    breakdown if desired.
    """
    p = subprocess.Popen(
        ["shellmetrics", "--csv", filepath],
        stderr=subprocess.PIPE,
        stdout=subprocess.PIPE,
    )
    out, err = p.communicate()
    out = out.decode("utf-8")

    # Use stringio to read the csv into csv parser
    f = StringIO(out)
    reader = csv.reader(f, delimiter=",")
    rows = list(reader)

    # The main is always the second row
    if rows[0][4] != "ccn":
        raise ValueError(f"Unexpected column headers for {filepath}:\n{out}")
    # This is the ccn score for <main> - it is a string parsed to int

    ccns = []
    for row in rows[1:]:
        # These don't seem to be included in the mean ccn in the pretty UI
        if row[1] in ["<begin>", "<end>"]:
            continue
        ccns.append(int(row[4]))

    # This should not happen, but for really simply stuff it seems to.
    # Let's give a value of 0
    if not ccns:
        print(f"Warning: no CCN scores found for {filepath}: assigning value of 0")
        return 0
    return statistics.mean(ccns)


def calculate_digests(filepath):
    """
    Note that we aren't removing duplicates here.
    """
    sha256_digest = content_hash(filepath, "sha256")
    sha1_digest = content_hash(filepath, "sha1")
    return sha256_digest, sha1_digest


def main():
    """
    jobspec feature parsing
    """
    parser = get_parser()
    args, _ = parser.parse_known_args()

    if not os.path.exists(args.input):
        sys.exit("An input JSON file is required.")

    # shellmetrics must be on path!
    if shutil.which("shellmetrics") is None:
        sys.exit(
            "Please install shellmetrics from: https://github.com/shellspec/shellmetrics"
        )

    with open(args.input, 'r') as fd:
        files = json.loads(fd.read())

    # These are in jobspec-conversion
    files = [f"../jobspec-conversion/{x}" for x in files]
    inserts = []
    total = len(files)

    for i, filename in enumerate(files):
        # Skip jobspec associated files
        print(f"{i}/{total}", end="\r")
        if "jobspec-cfg" in filename:
            continue
        sha256, sha1 = calculate_digests(filename)
        ccn = calculate_complexity(filename)
        inserts.append({"filename": filename, "sha256": sha256, "sha1": sha1, "ccn": ccn})

    # Make some plots!
    values = [x["ccn"] for x in inserts]
    values.sort()

    plt.figure(figsize=(6, 3))
    sns.histplot(values, bins=8)
    plt.title("Cyclomatic Complexity for 1K Job Specifications")
    plt.savefig(os.path.join(args.outdir, "cyclomatic-complexity.png"))
    plt.clf()


    print(np.mean(values)
    # Out[15]: np.float64(1.16)

    print(np.std(values))
    # np.float64(0.6959885056522126)


if __name__ == "__main__":
    main()
