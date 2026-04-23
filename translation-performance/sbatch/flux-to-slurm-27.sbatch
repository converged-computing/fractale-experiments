#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

echo "Start time:" $( date +%s )
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )