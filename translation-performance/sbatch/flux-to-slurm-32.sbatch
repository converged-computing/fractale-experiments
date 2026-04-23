#!/bin/bash
#SBATCH -N 2
#SBATCH -n 128

echo "Start time:" $( date +%s )
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
echo "End time:" $( date +%s )