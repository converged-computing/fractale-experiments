#!/bin/bash
#SBATCH --job-name=amg
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --output=amg_output_%j.txt
#SBATCH --error=amg_error_%j.txt

# Load necessary modules for AWS EFA
module load openmpi libfabric-aws

echo "Start time:" $( date +%s )

# Run the application via mpirun and Singularity
mpirun --bind-to core --map-by core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )