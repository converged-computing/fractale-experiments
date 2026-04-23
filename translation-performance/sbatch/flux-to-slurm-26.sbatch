#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

echo "Start time:" $( date +%s )
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )