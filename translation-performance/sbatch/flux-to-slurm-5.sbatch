#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

echo "Start time:" $( date +%s )

# The --cpu-bind=per-task option for srun is the closest equivalent to flux's cpu-affinity=per-task
srun --cpu-bind=per-task lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )