#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

echo "Start time:" $( date +%s )
srun --mpi=pmi2 amg -problem 2 -n 90 90 90 -P 4 4 4
echo "End time:" $( date +%s )