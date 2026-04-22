#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --job-name=amg_job
#SBATCH --output=amg_job.out
#SBATCH --error=amg_job.err

# Load necessary modules for MPI and AWS EFA networking
module load openmpi
module load libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Execute the application within the Singularity container using mpirun
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 3 8 8

# Echo end time
echo "End time:" $( date +%s )