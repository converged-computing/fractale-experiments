#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

echo "Start time:" $( date +%s )
srun --cpu-bind=cores kripke --niter 100 --zones 64,64,64 --procs 4,4,4
echo "End time:" $( date +%s )