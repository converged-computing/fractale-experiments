import argparse
import copy
import os
import json
import random
import sys
import fnmatch
import hashlib
import fractale.utils as utils
from colorama import Fore, Style

from fractale.core.plan import Plan


# Helper functions (from your original script)
def recursive_find(base, pattern="*"):
    for root, _, filenames in os.walk(base):
        for filename in fnmatch.filter(filenames, pattern):
            yield os.path.join(root, filename)


def content_hash(filename):
    sha1 = hashlib.sha1()
    with open(filename, "rb") as f:
        while True:
            data = f.read(BUF_SIZE)
            if not data:
                break
            sha1.update(data)
    return sha1.hexdigest()


def write_file(content, filename):
    with open(filename, "w") as fd:
        fd.write(content)


def write_json(obj, filename):
    with open(filename, "w") as fd:
        fd.write(json.dumps(obj, indent=4))


here = os.path.abspath(os.path.dirname(__file__))
root = os.path.dirname(here)

BUF_SIZE = 65536


def get_parser():
    parser = argparse.ArgumentParser(description="Agentic Jobspec Transformer")
    parser.add_argument(
        "--input",
        help="Input directory containing job scripts",
        default=os.path.join(root, "data"),
    )
    parser.add_argument(
        "--count",
        help="Number to sample",
        default=200,
        type=int,
    )
    parser.add_argument(
        "--output",
        help="Output directory for generated scripts",
        default=here,
    )
    return parser


def main():
    parser = get_parser()
    args, _ = parser.parse_known_args()

    if not args.output:
        sys.exit("You must define an --output directory")

    if not os.path.exists(args.input):
        sys.exit(f"Input directory does not exist: {args.input}")

    if not os.path.exists(args.output):
        os.makedirs(args.output)

    # Find unique job scripts to process
    seen = set()
    files = []
    for filename in recursive_find(args.input):
        digest = content_hash(filename)
        if digest in seen:
            continue
        seen.add(digest)
        files.append(filename)

    # Random shuffle so we sample across jobs.
    random.shuffle(files)

    print(f"⭐️ Found {len(files)} unique job scripts to process.")
    sample = []
    for filename in files:
        original_script = utils.read_file(filename)
        if len(original_script) < 1000:
            sample.append(filename)
            if len(sample) >= 200:
                break

    sample = [os.path.relpath(x, root) for x in sample]
    print(f"⭐️ Sampled {len(sample)} files under 1000 tokens.")
    write_json(sample, os.path.join(args.output, "sample-200.json"))


if __name__ == "__main__":
    main()
