#!/bin/sh
#
#FLUX: --job-name="perf_cylinder"
# The --partition=thin directive is ignored as per instructions.
#FLUX: --time-limit=2d
# The -n ${NP} directive is preserved by assuming the user will pass the task count at submission time.
# Example: flux submit -n 64 ./your_script.sh
# The -o and -e flags use slurm-specific format strings that are not supported in Flux and are omitted.

source ../compile/modules_snellius.sh
export CASE_ID=1
echo "Starting case: $CASE_ID"
# The custom mpiexecjl command is replaced with `flux mini run`
# The number of tasks is taken from the job submission, e.g., `flux submit -n 64`
flux mini run --project=../ julia -J ../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("run_case_benchmark.jl")'
