#!/bin/bash

# Slurm job directives
# Request 4 nodes for the job
#SBATCH --nodes=4
# Request 256 total tasks/processes
#SBATCH --ntasks=256
# Distribute 64 tasks to each of the 4 nodes
#SBATCH --ntasks-per-node=64
# Name the job for easier tracking
#SBATCH --job-name=amg_benchmark
# Specify output and error files
#SBATCH --output=amg_benchmark.out
#SBATCH --error=amg_benchmark.err

# --- Performance Tuning Directives ---

# --cpu-bind=per-task: Binds each task to a specific CPU core. This is the direct analog
# of Flux's 'cpu-affinity=per-task' and is crucial for preventing tasks from migrating
# between cores, which can hurt cache performance.
#SBATCH --cpu-bind=per-task

# --distribution=block:block: Distributes tasks to nodes in blocks and assigns tasks
# to cores within a node in blocks. For MPI applications, this can improve performance
# by placing communicating tasks closer together, potentially on the same NUMA node.
#SBATCH --distribution=block:block

# --exclusive: Requests exclusive access to the allocated nodes. This prevents other jobs
# from running on the same nodes, ensuring consistent performance for benchmarking by
# eliminating resource contention.
#SBATCH --exclusive

# Record the start time of the execution
echo "Start time:" $( date +%s )

# Run the application using srun
# srun is Slurm's tool for launching parallel jobs. It automatically propagates
# the resource requests from the #SBATCH directives to the job step.
# We are using Slurm's default MPI integration (typically PMIx), which is generally
# recommended for modern HPC systems over the older PMI2 requested in the Flux command.
srun amg -problem 2 -n 90 90 90 -P 4 8 8

# Record the end time of the execution
echo "End time:" $( date +%s )