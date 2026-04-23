#!/bin/bash

# Set a descriptive name for your job
#SBATCH --job-name=osu_allreduce

# Specify the number of nodes and tasks
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=64

# Direct output and error messages to files
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# PERFORMANCE: Request exclusive access to the nodes. This is crucial for
# benchmarking as it prevents other jobs from interfering with performance.
#SBATCH --exclusive

# PERFORMANCE: Bind each task to a physical core. This is analogous to Flux's
# 'cpu-affinity=per-task' and is critical for performance. It prevents the OS
# from migrating tasks, which improves cache hits and reduces communication latency.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Run the OSU Allreduce benchmark using srun
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )