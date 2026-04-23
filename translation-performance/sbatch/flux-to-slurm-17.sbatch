#!/bin/bash
#SBATCH -N 3
#SBATCH -n 192

# The Flux option '-o cpu-affinity=per-task' has no direct analog in the
# provided Slurm help text. Performance may be impacted if the Slurm
# default is not to bind tasks to cpus.

echo "Start time:" $( date +%s )
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8
echo "End time:" $( date +%s )