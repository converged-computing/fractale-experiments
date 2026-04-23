#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --job-name=osu_allreduce
#SBATCH --output=osu_allreduce-%j.out
#SBATCH --error=osu_allreduce-%j.err

echo "Start time:" $( date +%s )
srun --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )