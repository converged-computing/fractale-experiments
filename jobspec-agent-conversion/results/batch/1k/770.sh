#!/bin/bash -l
#FLUX: --job-name=planczos
#FLUX: --output=planczos.out
#FLUX: --error=planczos.err
#FLUX: --time-limit=20m
#FLUX: --ntasks=8
#FLUX: --nodes=1

# Set up environment
PRO=planczos

# Load required software modules
module load gcc/9.3.0-fasrc01 openmpi/4.0.5-fasrc01

# Run program
# The SLURM 'srun' command has been replaced with 'flux run'.
# The number of tasks is explicitly set to match the allocation.
flux run -n 8 ./${PRO}.x > ${PRO}.dat
