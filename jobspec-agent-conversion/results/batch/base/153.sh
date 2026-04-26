#!/bin/bash -l
#FLUX: --job-name=planczos
#FLUX: --output=planczos.out
#FLUX: --error=planczos.err
#FLUX: -t 20m
#FLUX: --ntasks=8
#FLUX: --nodes=1

# NOTE: The Slurm directive '--mem-per-cpu=4000' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

# Set up environment
PRO=planczos

# Load required software modules
module load gcc/9.3.0-fasrc01 openmpi/4.0.5-fasrc01

# Run program
# The 'srun' command has been converted to 'flux mini run'.
flux mini run -n 8 ./${PRO}.x > ${PRO}.dat

