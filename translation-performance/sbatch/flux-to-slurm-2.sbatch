#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192

echo "Start time:" $( date +%s )
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
echo "End time:" $( date +%s )