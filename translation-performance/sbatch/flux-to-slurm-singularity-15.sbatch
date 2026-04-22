#!/bin/bash
#SBATCH -N 1
#SBATCH -n 64
#SBATCH --job-name=amg_job
#SBATCH --output=amg_job.out
#SBATCH --error=amg_job.err

# Load required modules
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Execute the application within the singularity container using mpirun
mpirun -n 64 --map-by task --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 4 4

echo "End time:" $( date +%s )