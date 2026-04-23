#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

echo "Start time:" $( date +%s )
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )