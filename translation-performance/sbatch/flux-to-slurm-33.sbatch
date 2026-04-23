#!/bin/bash
#SBATCH -N 3
#SBATCH -n 192
#SBATCH --cpus-per-task=1

echo "Start time:" $( date +%s )
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )