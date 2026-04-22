#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64

# Load necessary modules
module load openmpi libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 4 4

# Echo end time
echo "End time:" $( date +%s )