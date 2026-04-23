#!/bin/bash
#SBATCH -N 2
#SBATCH -n 128
#SBATCH --cpus-per-task=1

echo "Start time:" $( date +%s )
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,4
echo "End time:" $( date +%s )