#!/bin/bash
#SBATCH -N 1
#SBATCH -n 64

echo "Start time:" $( date +%s )
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,4,4
echo "End time:" $( date +%s )