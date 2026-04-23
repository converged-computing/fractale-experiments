import argparse
import copy
import httpx
import time
import os
import json
import sys
import fnmatch
import hashlib
from colorama import Fore, Style
import fractale.core.registry as registry
from fractale.agents import init_backend
from fractale.engines import get_engine
from fractale.agents.base import init_backend

here = os.path.dirname(os.path.abspath(__file__))

# Note that we do not need these! The Slurm Operator (ours) works and we can run in containers akin to the Flux Operator
singularity_instructions = """
The Slurm cluster will run the application through Singularity. You must convert the initial command to run with Singularity. This means you should:

You must use mpirun as a prefix to the execution. It needs to specify any resource requirements (e.g., nodes and proc mapping, if requested) before the singularity command.
Instead of an execution to the <app> You will next need to do /shared/apps/bin/singularity exec --pwd <pwd> <container> <original command>
Add echo "Start time:" $( date +%s ) before your running command
Add echo "End time:" $( date +%s ) after your running command
You must load the module for openmpi and libfabric-aws

The following application containers MUST be used:
      lammps:  /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif
     amg2023: /shared/apps/containers/fractale-agent-experiments_amg2023.sif
     kripke:  /shared/apps/containers/fractale-agent-experiments_kripke.sif
 all-reduce: /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif
all-latency: /shared/apps/containers/fractale-agent-experiments_osu-latency.sif

The following pwd have application data. If a name is not in this list you do not need --pwd
      lammps:  /opt/lammps-reax
"""

slurm_instructions = """
You must NOT load any modules, as all software is active.
You MUSt add --mpi=pmix to all Slurm (e.g., srun) commands as we require it.
The user will not be able to edit your generated script - it MUST be in final form.

All applications are on the path except for:

 osu-all-reduce: /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
osu-latency: /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

Add echo "Start time:" $( date +%s ) before your running command
Add echo "End time:" $( date +%s ) after your running command
"""

with open(os.path.join(here, "sbatch.help"), 'r') as fd:
    sbatch_help = fd.read()

flux_commands = [
    # LAMMPS (lmp) - No Affinity
    "flux submit -N1 -n 64 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -N2 -n 128 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -N3 -n 192 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -N4 -n 256 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -N5 -n 320 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    # LAMMPS (lmp) - With Affinity
    "flux submit -o cpu-affinity=per-task -N1 -n 64 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -o cpu-affinity=per-task -N2 -n 128 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -o cpu-affinity=per-task -N3 -n 192 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -o cpu-affinity=per-task -N4 -n 256 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    "flux submit -o cpu-affinity=per-task -N5 -n 320 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns",
    # AMG - No Affinity
    "flux submit -N1 -n 64 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 4 4",
    "flux submit -N2 -n 128 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 4",
    "flux submit -N3 -n 192 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 3 8 8",
    "flux submit -N4 -n 256 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 8",
    "flux submit -N5 -n 320 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10",
    # AMG - With Affinity
    "flux submit -o cpu-affinity=per-task -N1 -n 64 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 4 4",
    "flux submit -o cpu-affinity=per-task -N2 -n 128 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 4",
    "flux submit -o cpu-affinity=per-task -N3 -n 192 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 3 8 8",
    "flux submit -o cpu-affinity=per-task -N4 -n 256 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 8",
    "flux submit -o cpu-affinity=per-task -N5 -n 320 -o pmi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10",
    # Kripke - No Affinity
    "flux submit -N1 -n 64 kripke --niter 100 --zones 64,64,64 --procs 4,4,4",
    "flux submit -N2 -n 128 kripke --niter 100 --zones 64,64,64 --procs 4,8,4",
    "flux submit -N4 -n 256 kripke --niter 100 --zones 64,64,64 --procs 4,8,8",
    # Kripke - With Affinity
    "flux submit -o cpu-affinity=per-task -N1 -n 64 kripke --niter 100 --zones 64,64,64 --procs 4,4,4",
    "flux submit -o cpu-affinity=per-task -N2 -n 128 kripke --niter 100 --zones 64,64,64 --procs 4,8,4",
    "flux submit -o cpu-affinity=per-task -N4 -n 256 kripke --niter 100 --zones 64,64,64 --procs 4,8,8",
    # OSU Allreduce - No Affinity
    "flux submit -N1 -n 64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -N2 -n 128 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -N3 -n 192 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -N4 -n 256 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -N5 -n 320 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    # OSU Allreduce - With Affinity
    "flux submit -o cpu-affinity=per-task -N1 -n 64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -o cpu-affinity=per-task -N2 -n 128 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -o cpu-affinity=per-task -N3 -n 192 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -o cpu-affinity=per-task -N4 -n 256 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    "flux submit -o cpu-affinity=per-task -N5 -n 320 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce",
    # OSU Latency - No Affinity
    "flux submit -N2 -n 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency",
    # OSU Latency - With Affinity
    "flux submit -o cpu-affinity=per-task -N2 -n 2 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency",
]


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
data_root = os.path.join(os.path.dirname(root), "jobspec-conversion", "data")

BUF_SIZE = 65536

# The agentic plan template
AGENTIC_PLAN = {
    "name": "Jobspec Transform",
    "agents": [{"path": "fractale_agents.hpc.job.JobTransformAgent"}],
    "steps": [
        {
            "name": "transform",
            "type": "agent",
            "tool": "job-transform",
            "inputs": {
                "goal": "Convert the following job command from %s to %s. Make a best effort to include every parameter, explain your choices, and explain when you are unable to do a mapping and the implications."
            },
        }
    ],
}


def get_parser():
    parser = argparse.ArgumentParser(description="Agentic Jobspec Transformer")
    parser.add_argument(
        "--output",
        help="Output directory for generated scripts",
        default=os.path.join(root, "results"),
    )
    parser.add_argument(
        "--improve", help="Improve upon results", action="store_true", default=False
    )
    parser.add_argument(
        "--with-singularity", help="Add singularity instructions", action="store_true", default=False
    )
    parser.add_argument(
        "--slurm-operator", help="Add slurm operator instructions", action="store_true", default=False
    )
    return parser


def main():
    parser = get_parser()
    args, _ = parser.parse_known_args()

    if not args.output:
        sys.exit("You must define an --output directory")

    if not os.path.exists(args.output):
        os.makedirs(args.output)

    # Structure to keep track of summary results
    # Detailed results will be saved to file (json)
    results = []
    success_count = 0
    failure_count = 0

    # Initialize backend
    registry.init_registry()
    init_backend()

    # Keep a count so we can skip of those we've done
    count = 0

    instructions = """
Please convert this command to run for the Slurm Workload manager.
The cluster will have the Elastic Fabric Adapter for low latency networking, running on hpc7g.6xlarge.
These details have no implications for the Slurm directives, they are for your FYI.
"""
        
    if args.improve:
        instructions += "\nSince we are converting to Slurm (with more flags and options) you MUST try to write the command to IMPROVE performance."
        instructions += (
            "\nPlease add comments to the sbatch script about what you did and why."
        )

    instructions += f"\nHere are directives for Slurm:\n{sbatch_help}"

    if args.slurm_operator:
        instructions += slurm_instructions

    if args.with_singularity:
        instructions += singularity_instructions

    for i, command in enumerate(flux_commands):
        print("-" * 50)
        print(f"Processing file {count+1}/{len(flux_commands)}")
        from_manager = "flux"
        to_managers = ["slurm"]
        for to_manager in to_managers:
            outfile_path = os.path.join(
                args.output, f"{from_manager}-to-{to_manager}-{i}-result.json"
            )
            if os.path.exists(outfile_path):
                continue
            print(f"  Attempting transformation: {from_manager} -> {to_manager}")

            # save results some consistent prefix
            context = {
                "from_manager": from_manager,
                "to_manager": to_manager,
                "script": command,
                "instruction": instructions,
                "max_turns": 5,
            }

            # Update the engine to have the new plan
            plan = copy.deepcopy(AGENTIC_PLAN)
            plan["steps"][0]["inputs"] = context

            # Re-init each time.
            init_backend()
            engine = get_engine(plan, max_attempts=5)
            time.sleep(2)
            print(engine.max_attempts)
            engine._max_attempts = 5

            # The core agentic call replaces the old transformer.convert()
            try:
                result = engine.run()
            except httpx.ReadError:
                continue

            result["plan"] = plan
            result["command"] = command

            # Save the new jobspec to the equivalent place on the filesystem
            outdir = os.path.dirname(outfile_path)
            if not os.path.exists(outdir):
                os.makedirs(outdir)
            write_json(result, outfile_path)

            # Log success
            success_count += 1
            results.append(
                {
                    "command": command,
                    "from": from_manager,
                    "to": to_manager,
                    "status": "success",
                    "output_file": outfile_path,
                }
            )
            print(
                Fore.GREEN
                + f"  ✅ Success: Saved to {os.path.basename(outfile_path)}"
                + Style.RESET_ALL
            )
            count += 1

    # NOTE: here success means the functions worked, NOT that the result was valid.
    print("\n" + "=" * 50)
    print("Processing Complete.")
    print(f"\nSummary:")
    print(
        Fore.GREEN + f"  Successful Transformations: {success_count}" + Style.RESET_ALL
    )
    print(Fore.RED + f"  Failed Transformations:     {failure_count}" + Style.RESET_ALL)

    # Save the detailed results log for later analysis
    results_log_path = os.path.join(args.output, "experiment-summary.json")
    write_json(results, results_log_path)
    print(f"\nDetailed log saved to: {results_log_path}")


if __name__ == "__main__":
    main()
