#!/bin/bash
#SBATCH --job-name=kripke_conversion
#SBATCH --nodes=1
#SBATCH --ntasks=64

# The following directive improves performance by pinning tasks to specific CPU cores.
# This can reduce cache contention and improve memory locality.
# It is analogous to the 'cpu-affinity=per-task' option in the original Flux command.
#SBATCH --cpu-bind=cores

echo "Start time:" $(date +%s)

srun kripke --niter 100 --zones 64,64,64 --procs 4,4,4

echo "End time:" $(date +%s)