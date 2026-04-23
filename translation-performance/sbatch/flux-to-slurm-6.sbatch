#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

# The flux option '-o cpu-affinity=per-task' was not translated as no direct Slurm equivalent was found in the provided documentation.
# This may have performance implications.

echo "Start time:" $( date +%s )
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
echo "End time:" $( date +%s )