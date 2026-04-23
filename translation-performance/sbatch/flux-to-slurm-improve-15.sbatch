#!/bin/bash
#
# Auto-generated Slurm batch script from Flux command

# Set the job name
#SBATCH --job-name=amg_job

# Specify the number of nodes
#SBATCH --nodes=1

# Specify the total number of tasks
#SBATCH --ntasks=64

# Set the names for standard output and error files
#SBATCH --output=amg_job.out
#SBATCH --error=amg_job.err

# IMPROVE PERFORMANCE: Bind tasks directly to CPU cores.
# This is the Slurm equivalent of Flux's `-o cpu-affinity=per-task` option.
# It prevents the OS from migrating tasks between cores, which improves
# cache performance and reduces context-switching overhead for HPC jobs.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Run the application using srun. The --mpi=pmix flag is required.
# The application and its arguments are passed directly.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 4 4

echo "End time:" $( date +%s )