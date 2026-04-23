#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

echo "Start time:" $( date +%s )
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,8
echo "End time:" $( date +%s )