#!/bin/bash

# Job name
#SBATCH --job-name=osu_allreduce_benchmark

# Number of nodes requested
#SBATCH --nodes=5

# Total number of tasks to be started
#SBATCH --ntasks=320

# To improve performance, we specify the number of tasks per node.
# For hpc7g.6xlarge with 64 vCPUs, this places one task per vCPU.
#SBATCH --ntasks-per-node=64

# We request exclusive access to the nodes for performance-sensitive benchmarks
# to ensure no other jobs interfere with execution.
#SBATCH --exclusive

# Standard output and error files
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

echo "Start time:" $( date +%s )

# Run the benchmark. srun is the Slurm command to launch parallel tasks.
# We add '--cpu-bind=cores' to bind each MPI rank to a specific CPU core.
# This improves performance by reducing context switching and improving cache efficiency.
srun --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )