#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

echo "Start time:" $( date +%s )
srun amg -problem 2 -n 90 90 90 -P 4 8 8
echo "End time:" $( date +%s )