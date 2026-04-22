#!/bin/bash
#
# This script was converted from a Flux command to run on a Slurm cluster.

# -- JOB DIRECTIVES --

#SBATCH --job-name=amg_job
# Set a descriptive job name

#SBATCH --nodes=4
# We request 4 nodes, same as the original Flux command (-N4).

#SBATCH --ntasks=256
# We request 256 total MPI tasks, same as the original Flux command (-n 256).

#SBATCH --ntasks-per-node=64
# For optimal distribution, we specify 64 tasks per node (256 tasks / 4 nodes).

#SBATCH --exclusive
# This is a performance enhancement. It ensures that our job has exclusive access
# to the allocated nodes, preventing interference from other jobs.

#SBATCH --output=amg_run_%j.out
# Direct the standard output to a file named with the job ID.

#SBATCH --error=amg_run_%j.err
# Direct the standard error to a file named with the job ID.

# -- ENVIRONMENT SETUP --

echo "Loading modules..."
# Load the required modules for MPI and the AWS EFA network fabric.
module load openmpi libfabric-aws

# -- EXECUTION --

echo "Start time:" $( date +%s )

# The original command was 'flux submit -o cpu-affinity=per-task ... amg ...'
# The '-o cpu-affinity=per-task' is translated to '--bind-to core' for OpenMPI's mpirun.
# This pins each task to a physical CPU core, improving performance and cache efficiency.
mpirun -np 256 --bind-to core \
    /shared/apps/bin/singularity exec \
    /shared/apps/containers/fractale-agent-experiments_amg2023.sif \
    amg -problem 2 -n 90 90 90 -P 4 8 8

echo "End time:" $( date +%s )