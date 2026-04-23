#!/bin/bash
#
# This script runs the OSU Allreduce benchmark.
# It has been converted from a flux command and optimized for Slurm.

# Job Details
#SBATCH --job-name=osu_allreduce_benchmark  # Name for the job
#SBATCH --output=osu_allreduce_%j.out       # Standard output file
#SBATCH --error=osu_allreduce_%j.err        # Standard error file

# Resource Allocation
# We are requesting 5 nodes, the same as the original flux command (-N5).
#SBATCH --nodes=5
# We are requesting 320 tasks in total, same as the original flux command (-n 320).
# This means we'll have 64 tasks per node (320 tasks / 5 nodes).
#SBATCH --ntasks=320
# To ensure that tasks are distributed evenly across the nodes, we can specify ntasks-per-node.
# This improves load balancing for communication-heavy jobs.
#SBATCH --ntasks-per-node=64

# Performance Optimizations
# We request exclusive access to the nodes to prevent other jobs from
# interfering and ensure consistent performance measurements.
#SBATCH --exclusive
# The original flux command used '--cpu-affinity=per-task'.
# For better performance with MPI applications, we bind tasks to cores.
# This prevents the OS from migrating tasks between cores, which can improve
# cache performance and reduce context switching.
#SBATCH --cpu-bind=cores
# We use a cyclic distribution to spread the tasks across the nodes and sockets
# in a round-robin fashion. This can help balance the communication load for
# collective operations like all-reduce.
#SBATCH --distribution=cyclic:cyclic

echo "Start time:" $( date +%s )

# Run the benchmark
# srun is the Slurm command to launch parallel jobs.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )