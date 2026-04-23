#!/bin/bash

# Set the job name for easier identification
#SBATCH --job-name=amg_job

# Specify the number of nodes required, equivalent to -N3 in the flux command.
#SBATCH --nodes=3

# Specify the total number of tasks (processes) to be launched, equivalent to -n 192 in flux.
#SBATCH --ntasks=192

# To improve performance, we explicitly define the number of tasks per node.
# This helps the scheduler with more efficient process placement.
# (192 total tasks / 3 nodes = 64 tasks per node)
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes.
# This is a key performance improvement, as it ensures no other jobs can interfere
# with this job's access to resources like network or memory bandwidth.
#SBATCH --exclusive

# Define the files for standard output and error. Using %j inserts the job ID.
#SBATCH --output=amg_job_%j.out
#SBATCH --error=amg_job_%j.err

# Echo the start time for tracking purposes.
echo "Start time:" $( date +%s )

# Launch the parallel application using srun.
# The --mpi=pmix flag is added as required to specify the MPI process management interface.
# The application 'amg' and its arguments are passed directly.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8

# Echo the end time for tracking purposes.
echo "End time:" $( date +%s )