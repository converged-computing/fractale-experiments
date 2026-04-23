#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192

echo "Start time:" $( date +%s )
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )