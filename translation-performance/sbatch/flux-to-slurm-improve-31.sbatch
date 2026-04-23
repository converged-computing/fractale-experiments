#!/bin/bash

# Slurm Job Directives

# Job name for identification
#SBATCH --job-name=osu_allreduce_benchmark

# Request 1 node
#SBATCH --nodes=1

# Request 64 tasks in total
#SBATCH --ntasks=64

# Ensure all 64 tasks are on the same node
#SBATCH --ntasks-per-node=64

# Standard output and error files
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# --- Performance Enhancements ---

# Request exclusive access to the node to prevent interference from other jobs.
# This is crucial for obtaining accurate and repeatable benchmark results.
#SBATCH --exclusive

# Bind each task to a specific CPU core. This improves performance by
# increasing cache efficiency and reducing context switching. It is the
# analogous and performance-oriented translation of flux's 'cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# --- Execution --- 

# Record the start time of the benchmark execution.
echo "Start time:" $( date +%s )

# Run the OSU AllReduce benchmark using srun.
# The --mpi=pmix flag is included as required by the user.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Record the end time of the benchmark execution.
echo "End time:" $( date +%s )