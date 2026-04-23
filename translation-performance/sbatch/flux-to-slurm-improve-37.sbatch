#!/bin/bash

# SBATCH Directives

# Request 2 nodes, which matches the original '-N2' in the Flux command.
#SBATCH -N 2

# Request 2 total tasks (MPI ranks), matching the original '-n 2'.
#SBATCH -n 2

# Explicitly request 1 task per node. For a 2-node, 2-task latency
# benchmark, this ensures the tasks are placed on separate nodes.
#SBATCH --ntasks-per-node=1

# Provide a name for the job for easier tracking.
#SBATCH -J osu_latency

# --- Performance-Enhancing Directives ---

# Request exclusive access to the nodes. This is crucial for benchmarking
# as it prevents other jobs from running on the same nodes and
# interfering with the results.
#SBATCH --exclusive

# Bind each task to a specific physical core. This is the direct analog
# of Flux's 'cpu-affinity=per-task'. It improves performance by preventing
# the OS from moving the task between cores, which reduces cache misses
# and context switching overhead.
#SBATCH --cpu-bind=cores

# Disable Simultaneous Multithreading (SMT/Hyper-Threading). For many
# latency-sensitive HPC workloads, a single task can run faster when it
# has access to the full resources of a physical core without sharing
# them with another logical thread.
#SBATCH --hint=nomultithread

# --- Job Execution ---

echo "Start time:" $( date +%s )

# Use srun to launch the parallel application across the allocated resources.
# The path to the executable is provided as specified.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

echo "End time:" $( date +%s )