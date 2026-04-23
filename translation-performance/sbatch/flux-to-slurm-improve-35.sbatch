#!/bin/bash

# SBATCH --job-name=osu_allreduce_benchmark

# Request 5 nodes, same as the original Flux command (-N5)
# SBATCH --nodes=5

# Request 320 total tasks, same as the original Flux command (-n 320)
# SBATCH --ntasks=320

# Calculate and specify tasks per node (320 tasks / 5 nodes = 64)
# This helps the scheduler with placement and ensures an even distribution.
# SBATCH --ntasks-per-node=64

# Bind each task to a specific CPU core. This is the direct Slurm analog
# to the Flux 'cpu-affinity=per-task' option and is critical for performance
# by preventing task migration and improving cache utilization.
# SBATCH --cpu-bind=tasks

# Request exclusive access to the nodes. This is a key performance improvement
# as it prevents any other jobs from running on the nodes, ensuring that
# the benchmark results are not affected by external "noise" or resource contention.
# SBATCH --exclusive

# Standard output and error files
# SBATCH --output=osu_allreduce_%j.out
# SBATCH --error=osu_allreduce_%j.err

echo "Start time:" $( date +%s )

# Execute the benchmark using srun. 
# The --mpi=pmix flag is added as required to specify the MPI implementation.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )