#!/bin/bash
#
# This script is a conversion from a flux command to a Slurm batch job.
# It includes optimizations for running a point-to-point latency benchmark.

# Set the job name for easier identification in the queue
#SBATCH --job-name=osu_latency_benchmark

# Request 2 nodes, as specified in the original Flux command (-N2)
#SBATCH -N 2

# Request 2 total tasks, as specified in the original Flux command (-n2)
#SBATCH -n 2

# --- Performance Optimizations ---

# To accurately measure inter-node latency, we must ensure that only one
# MPI task runs on each of the two nodes.
#SBATCH --ntasks-per-node=1

# Request exclusive access to the nodes. This prevents other jobs from running
# on the same nodes and creating CPU or network interference (jitter),
# which is critical for a sensitive latency benchmark.
#SBATCH --exclusive

# --- Job Execution ---

# Add a timestamp for when the job starts
echo "Start time:" $( date +%s )

# Execute the benchmark using srun.
# The --mpi=pmix flag is included as required by the cluster configuration.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

# Add a timestamp for when the job ends
echo "End time:" $( date +%s )