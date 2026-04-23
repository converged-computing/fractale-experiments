#!/bin/bash
#SBATCH --job-name=osu_latency_benchmark
#
# Request 2 nodes for the job.
#SBATCH --nodes=2
#
# Request a total of 2 MPI tasks for the job.
#SBATCH --ntasks=2
#
# Distribute one task per node for this point-to-point benchmark.
#SBATCH --ntasks-per-node=1
#
# For performance, bind each task directly to a physical core.
# This prevents the operating system from moving the task between cores,
# reducing cache misses and context-switching overhead.
#SBATCH --cpu-bind=cores
#
# Request exclusive access to the nodes. This is critical for
# networking benchmarks to prevent other jobs from causing interference.
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# Run the benchmark using srun. The --mpi=pmix flag is added as required.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

echo "End time:" $( date +%s )