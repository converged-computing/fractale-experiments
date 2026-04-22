#!/bin/bash

# SBATCH Directives

# Request 2 nodes for the job.
# SBATCH -N 2

# Request a total of 128 MPI tasks for the job.
# SBATCH -n 128

# Explicitly request 64 tasks per node (128 tasks / 2 nodes).
# This ensures an even distribution of work.
# SBATCH --ntasks-per-node=64

# Set a descriptive name for the job for easier tracking.
# SBATCH --job-name=osu_allreduce_benchmark

# Allocate nodes for exclusive use. This is crucial for performance benchmarks
# as it prevents interference from other jobs on the same nodes.
# SBATCH --exclusive

# Bind tasks directly to CPU cores. This can significantly improve performance
# by preventing task migration and improving cache utilization.
# SBATCH --cpu-bind=cores

# Set the standard output and error file names, using the job ID (%j) for uniqueness.
# SBATCH --output=osu_allreduce_%j.out
# SBATCH --error=osu_allreduce_%j.err


# Load necessary modules for MPI and AWS EFA networking.
# This ensures the environment is correctly set up for the parallel run.
module load openmpi
module load libfabric-aws

# Echo the start time (in Unix epoch seconds) for benchmarking.
echo "Start time:" $( date +%s )

# Execute the OSU All-Reduce benchmark using mpirun.
# The application is run inside a Singularity container to ensure a consistent runtime environment.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echo the end time (in Unix epoch seconds) for benchmarking.
echo "End time:" $( date +%s )