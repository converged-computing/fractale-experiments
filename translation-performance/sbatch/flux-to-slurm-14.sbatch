#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

echo "Start time:" $( date +%s )
srun --mpi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10
echo "End time:" $( date +%s )