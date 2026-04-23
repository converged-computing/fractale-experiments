#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

# The Flux option '-o cpu-affinity=per-task' is translated to the srun option '--cpu-bind=cores'
# to ensure each task is bound to a single CPU core.

echo "Start time:" $( date +%s )

srun --mpi=pmix --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )