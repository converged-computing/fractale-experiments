#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --job-name=amg
#SBATCH --output=amg.out
#SBATCH --error=amg.err

# Load required modules
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )