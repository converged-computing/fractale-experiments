#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

echo "Start time:" $( date +%s )
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4
echo "End time:" $( date +%s )