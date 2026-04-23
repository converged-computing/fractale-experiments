#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192

echo "Start time:" $( date +%s )
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8
echo "End time:" $( date +%s )