#!/bin/bash
#
# Slurm batch script for Kripke
# Converted from: flux submit -N2 -n 128 kripke --niter 100 --zones 64,64,64 --procs 4,8,4

# --- Slurm Directives ---
# Request 2 nodes for the job
#SBATCH --nodes=2

# Request a total of 128 tasks for the job
#SBATCH --ntasks=128

# Explicitly request 64 tasks per node (128 tasks / 2 nodes) to ensure even distribution.
#SBATCH --ntasks-per-node=64

# Give the job a name for easier tracking.
#SBATCH --job-name=kripke

# Set a wall clock time limit for the job. This is often required.
#SBATCH --time=01:00:00


# --- Performance Optimizations ---
# Request exclusive access to the nodes. This prevents other jobs from running on
# the same nodes and interfering with the performance of this job.
#SBATCH --exclusive

# Bind tasks to cores to improve performance by reducing context switching and
# improving cache utilization.
#SBATCH --cpu-bind=cores


# --- Job Setup ---
# Load necessary modules for MPI and AWS EFA networking
echo "Loading modules..."
module load openmpi
module load libfabric-aws


# --- Job Execution ---
echo "Starting job execution..."
echo "Start time:" $( date +%s )

# The original command is executed within a Singularity container using mpirun.
# The --procs flag is an application-level argument for Kripke's internal decomposition.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,4

echo "End time:" $( date +%s )
echo "Job finished."