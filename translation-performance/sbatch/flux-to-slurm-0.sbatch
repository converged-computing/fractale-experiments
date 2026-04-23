#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

echo "Start time:" $( date +%s )
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
echo "End time:" $( date +%s )