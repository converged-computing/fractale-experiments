#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --job-name=amg
#SBATCH --output=amg.out

# Load necessary modules
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 8

echo "End time:" $( date +%s )