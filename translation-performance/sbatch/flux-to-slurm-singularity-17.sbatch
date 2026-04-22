#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --job-name=amg

# Load necessary modules
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
# The Flux '-o cpu-affinity=per-task' is translated to '--cpu-bind cores' for mpirun.
mpirun --cpu-bind cores /shared/apps/bin/singularity exec \
    /shared/apps/containers/fractale-agent-experiments_amg2023.sif \
    amg -problem 2 -n 90 90 90 -P 3 8 8

echo "End time:" $( date +%s )