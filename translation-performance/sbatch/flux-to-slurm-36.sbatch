#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=2

echo "Start time:" $( date +%s )
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
echo "End time:" $( date +%s )