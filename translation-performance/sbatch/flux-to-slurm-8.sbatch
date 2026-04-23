#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

echo "Start time:" $( date +%s )

srun --cpu-bind=per-task lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )