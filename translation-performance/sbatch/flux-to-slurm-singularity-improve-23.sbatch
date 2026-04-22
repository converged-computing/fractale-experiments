#!/bin/bash
#
# This script is a conversion from a flux command to a Slurm batch job.
#

# Job Name for easier identification in the queue
#SBATCH --job-name=kripke_performance_run

# Request 1 node, as specified by -N1 in the original flux command.
#SBATCH --nodes=1

# Request 64 total tasks, as specified by -n 64 in the original flux command.
#SBATCH --ntasks=64

# For performance, request exclusive access to the node. This prevents
# other jobs from running on the same node and interfering with this job's performance.
#SBATCH --exclusive

# Bind tasks to cores for better performance. This is analogous to the flux
# '-o cpu-affinity=per-task' option and helps improve cache performance by
# preventing tasks from migrating between CPU cores during execution.
#SBATCH --cpu-bind=cores

# Define the files for standard output and error. %j is the job ID.
#SBATCH --output=kripke_run_%j.out
#SBATCH --error=kripke_run_%j.err

# --- Job Execution Environment Setup ---

# Load the necessary modules.
# openmpi is required for the 'mpirun' command and MPI libraries.
# libfabric-aws is crucial for enabling high-performance networking with the Elastic Fabric Adapter (EFA).
module load openmpi
module load libfabric-aws

# --- Job Execution ---

# Record the start time (Unix timestamp) for benchmarking.
echo "Start time:" $( date +%s )

# Run the kripke application using mpirun to launch the MPI tasks.
# The application itself is executed inside the specified Singularity container.
mpirun -np 64 /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,4,4

# Record the end time (Unix timestamp) for benchmarking.
echo "End time:" $( date +%s )