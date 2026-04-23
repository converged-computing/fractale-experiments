#!/bin/bash

#SBATCH --nodes=2
#SBATCH --ntasks=128

echo "Start time:" $( date +%s )
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4
echo "End time:" $( date +%s )