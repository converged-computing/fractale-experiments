#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --job-name=osu_allreduce_benchmark

echo "Start time:" $( date +%s )

srun --cpu-bind=per-task /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )