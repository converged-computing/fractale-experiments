#!/bin/bash

#SBATCH --nodes=4
#SBATCH --ntasks=256

# The following flux option was not translated: -o cpu-affinity=per-task
# This may have performance implications.

echo "Start time:" $( date +%s )

srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )