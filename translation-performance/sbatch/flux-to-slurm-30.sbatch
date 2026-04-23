#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

echo "Start time:" $( date +%s )
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )