#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192

# Echos for timing as requested
echo "Start time:" $( date +%s )

srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echos for timing as requested
echo "End time:" $( date +%s )