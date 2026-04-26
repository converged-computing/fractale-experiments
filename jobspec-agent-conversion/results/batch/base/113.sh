#!/bin/sh
#
#FLUX: --job-name=perf_cylinder
#FLUX: --queue=thin
#FLUX: --time-limit=2d
# The number of tasks (-n) must be specified as a command-line argument to this script.
# For example: flux submit -n 16 ./script.sh 16
#
# The SLURM output format with task and node IDs is not supported.
# All output will go to a single file pair.
#FLUX: --output=stdout-benchmark/flux-{id}.out
#FLUX: --error=stdout-benchmark/flux-{id}.err

source ../compile/modules_snellius.sh
export CASE_ID=1
echo "Starting case: $CASE_ID"

# The mpiexecjl command is replaced with flux run.
# The number of tasks is taken from the first command line argument to the script.
flux run -n $1 julia -J ../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("run_case_benchmark.jl")'
