#!/bin/bash
#SBATCH -N 5
#SBATCH -n 320

echo "Start time:" $( date +%s )
srun --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
echo "End time:" $( date +%s )