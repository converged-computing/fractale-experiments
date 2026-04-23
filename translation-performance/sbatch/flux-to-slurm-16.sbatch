#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

echo "Start time:" $( date +%s )

# The --cpu-bind=per-task option for srun is analogous to flux's -o cpu-affinity=per-task
# The -o pmi=pmi2 option has no direct Slurm equivalent and is omitted.
srun amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )