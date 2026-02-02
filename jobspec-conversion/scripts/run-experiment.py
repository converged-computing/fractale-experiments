import argparse
import copy
import time
import os
import json
import random
import sys
import fnmatch
import hashlib
import fractale.utils as utils
from colorama import Fore, Style

from fractale.engines import get_engine
from fractale.core.plan import Plan

def detect_transformer(jobspec):
    """
    Quick and dirty detection.

    This is from our original fractale code, and it is simple enough to use
    here just for the experiment.
    """
    content = utils.read_file(jobspec)
    if "#FLUX" in content and "FLUX_CAPACITOR" not in content:
        return "flux"
    if "#MSUB " in content:
        return "moab"
    if "#SBATCH " in content:
        return "slurm"
    if "kind:" in content and "Job" in content:
        return "kubernetes"
    if "#PBS " in content:
        return "pbs"
    if "#BSUB" in content:
        return "lsf"
    if "#OAR" in content:
        return "oar"
    if "#COBALT" in content:
        return "cobalt"
    raise ValueError("Unkown transformer.")


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

# The agentic plan template
AGENTIC_PLAN = {
    "name": "Transform Jobspec Between Managers",
    "steps": [
        {
            "name": "transform",
            "type": "agent",
            "prompt": "transform_jobspec_expert",
            "allow_tools": True, # Assume the agent has tools for transformation
            "inputs": {
                "from_manager": "{{ from_manager }}",
                "to_manager": "{{ to_manager }}",
                "script": "{{ script }}",
            },
            "transitions": {
                "failed": "transform",
                "success": "validate"
            }
        },
        {
            "name": "validate",
            "type": "agent",
            "prompt": "validate_jobspec_expert",
            "inputs": {
                "script": "{{ result.jobspec }}"
            }
        }
    ]
}


def get_parser():
    parser = argparse.ArgumentParser(description="Agentic Jobspec Transformer")
    parser.add_argument(
        "--input",
        help="Input directory containing job scripts",
        default=os.path.join(root, "data"),
    )
    parser.add_argument(
        "--limit",
        help="Max number of files to process",
        default=None,
        type=int,
    )
    parser.add_argument(
        "--output",
        help="Output directory for generated scripts",
    )
    parser.add_argument(
        "--model",
        help="Name of model",
        default="gemini",
        choices=['gemini'], # TODO add others
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

    print(f"⭐️ Found {len(files)} unique job scripts to process.")
    
    # Structure to keep track of summary results
    # Detailed results will be saved to file (json)
    results = []
    success_count = 0
    failure_count = 0

    # We are going to cheat a little and instantiate this once (here) with a faux plan    
    engine = get_engine(AGENTIC_PLAN, engine="autogen", backend=args.model, max_attempts=5)
    limit = args.limit if args.limit is not None else len(files)
    print(f"Will process {limit} files")
    time.sleep(2)

    # Random shuffle so we sample across jobs.
    random.shuffle(files)

    # Keep a count so we can skip of those we've done
    count = 0

    for _, filename in enumerate(files):

        if count >= limit:
            print(f"Reached limit {limit}, completing.")
            break     
        print("-" * 50)
        print(f"Processing file {count+1}/{limit}: {os.path.basename(filename)}")        
        original_script = utils.read_file(filename)
        
        try:
            from_manager = detect_transformer(filename)
        except ValueError:
            print(Fore.YELLOW + f"  Skipping file, could not detect source manager." + Style.RESET_ALL)
            results.append({
                "source_file": filename,
                "status": "skipped",
                "reason": "Unknown source workload manager"
            })
            continue

        # Define the target managers for conversion
        # Note that I'm including TO slurm even though we do not have a validation
        # step here.
        to_managers = ["flux", "slurm"]

        for to_manager in to_managers:

            # I originally was filtering out TO the same manager,
            # but I am now curious how the model will handle it.
            # if from_manager == to_manager:
            #    continue

            relative_path = os.path.relpath(filename, args.input)
            # TODO: run for same sample some number of times and see how different.
            outfile_path = os.path.join(args.output, relative_path + f"-{to_manager}-result.json")                
            if os.path.exists(outfile_path):
                continue

            print(f"  Attempting transformation: {from_manager} -> {to_manager}")
            
            # save results some consistent prefix
            context = {
                "from_manager": from_manager,
                "to_manager": to_manager,
                "script": original_script,
            }

            try:
                # Update the engine to have the new plan
                plan = copy.deepcopy(AGENTIC_PLAN)
                plan['steps'][0]['inputs'] = context
                engine.reset(Plan(plan))

                # The core agentic call replaces the old transformer.convert()
                steps = engine.run(context)
                result = {'steps': steps, "plan": plan}
                
                # Save the new jobspec to the equivalent place on the filesystem
                outdir = os.path.dirname(outfile_path)
                if not os.path.exists(outdir):
                    os.makedirs(outdir)                
                write_json(result, outfile_path)
                
                # Log success
                success_count += 1
                results.append({
                    "source_file": filename,
                    "from": from_manager,
                    "to": to_manager,
                    "status": "success",
                    "output_file": outfile_path
                })
                print(Fore.GREEN + f"  ✅ Success: Saved to {os.path.basename(outfile_path)}" + Style.RESET_ALL)

            except Exception as e:
                # Log failure
                failure_count += 1
                results.append({
                    "source_file": filename,
                    "from": from_manager,
                    "to": to_manager,
                    "status": "failure",
                    "error": str(e)
                })
                print(Fore.RED + f"  ❌ Failure: {e}" + Style.RESET_ALL)

        count+=1

    # NOTE: here success means the functions worked, NOT that the result was valid.
    print("\n" + "=" * 50)
    print("Processing Complete.")
    print(f"\nSummary:")
    print(Fore.GREEN + f"  Successful Transformations: {success_count}" + Style.RESET_ALL)
    print(Fore.RED + f"  Failed Transformations:     {failure_count}" + Style.RESET_ALL)

    # Save the detailed results log for later analysis
    results_log_path = os.path.join(args.output, "experiment-summary.json")        
    write_json(results, results_log_path)
    print(f"\nDetailed log saved to: {results_log_path}")


if __name__ == "__main__":
    main()
