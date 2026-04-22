#!/bin/bash

# SBATCH --job-name=amg_job
# Set the total number of nodes requested for the job.
# SBATCH --nodes=3

# Set the total number of tasks (MPI processes) to be launched.
# SBATCH --ntasks=192

# Set the number of tasks per node. 192 tasks / 3 nodes = 64 tasks/node.
# SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This is a performance improvement
# as it prevents other jobs from interfering with this one.
# SBATCH --exclusive

# Distribute tasks cyclically across nodes. This can improve performance for
# communication-intensive applications by spreading processes across the network fabric.
# SBATCH --distribution=cyclic:cyclic

# Load the required modules for MPI and AWS high-speed networking.
module load openmpi
module load libfabric-aws

# Record the start time of the job.
echo "Start time:" $( date +%s )

# Execute the application using mpirun and Singularity.
# The application 'amg' is run from within the specified container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 3 8 8

# Record the end time of the job.
echo "End time:" $( date +%s )