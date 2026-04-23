#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

# The following flux option has no direct Slurm equivalent in the provided documentation:
# -o cpu-affinity=per-task
# This may impact performance as task placement will be handled by the OS.

# Slurm typically auto-detects the appropriate PMI library.
# The flux option '-o pmi=pmi2' was omitted.

echo "Start time:" $( date +%s )
srun amg -problem 2 -n 90 90 90 -P 4 8 8
echo "End time:" $( date +%s )