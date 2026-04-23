#!/bin/bash

# Slurm Directives
# ----------------

# Set the job name for easy identification
#SBATCH --job-name=amg_benchmark

# Request 1 compute node. This corresponds to the '-N1' in the flux command.
#SBATCH --nodes=1

# Request 64 tasks on the node. This corresponds to the '-n 64' in the flux command.
#SBATCH --ntasks-per-node=64

# PERFORMANCE: Request exclusive access to the node. This is a best practice
# for performance-sensitive applications as it prevents other jobs from
# competing for resources like memory bandwidth and network.
#SBATCH --exclusive

# Define the output and error file names, using the job ID (%j) for uniqueness.
#SBATCH --output=amg_output_%j.log
#SBATCH --error=amg_error_%j.log

# -- End of Slurm Directives --


# Echo the start time in Unix epoch format for easy calculation
echo "Start time:" $(date +%s)

# Launch the parallel application using srun.
# --cpu-bind=cores: PERFORMANCE: This option binds each task to a physical CPU core.
# This prevents the OS from moving tasks between cores, which improves
# cache performance and reduces execution time variability.
# --mpi=pmix: PERFORMANCE: This specifies the PMIx library for process management.
# PMIx is a modern standard that is generally more performant and scalable than PMI2,
# which was requested in the original flux command.
srun --cpu-bind=cores --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 4 4


# Echo the end time in Unix epoch format
echo "End time:" $(date +%s)