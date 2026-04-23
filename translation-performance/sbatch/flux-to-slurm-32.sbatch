#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

# The flux 'cpu-affinity=per-task' option does not have a direct
# equivalent in the provided Slurm options. The '--cpu-bind' directive
# is the typical analog but is not listed in the provided documentation.

echo "Start time:" $( date +%s )

srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )