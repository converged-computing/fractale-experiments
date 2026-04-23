#!/bin/bash
#SBATCH -N 4
#SBATCH -n 256
#SBATCH --cpus-per-task=1

echo "Start time:" $( date +%s )
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8
echo "End time:" $( date +%s )