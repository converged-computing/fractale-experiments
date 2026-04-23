#!/bin/bash

# Slurm Job Directives

# Job name
#SBATCH --job-name=osu_allreduce_benchmark

# Number of nodes
# We are requesting 2 nodes, same as the original flux command (-N2)
#SBATCH --nodes=2

# Number of tasks (MPI ranks)
# We are requesting 128 tasks in total, same as the original flux command (-n 128)
#SBATCH --ntasks=128

# Tasks per node
# Explicitly setting 64 tasks per node (128 tasks / 2 nodes) for even distribution.
# This helps the scheduler place tasks optimally, especially on homogenous clusters.
#SBATCH --ntasks-per-node=64

# Ensure exclusive access to the nodes
# This is critical for performance measurement to avoid interference from other jobs.
#SBATCH --exclusive

# Distribute tasks in a block-wise fashion across nodes and bind tasks to cores.
# This improves locality for communication patterns and ensures one task per physical core.
#SBATCH --distribution=block:block
#SBATCH --cpu-bind=cores

# Set the output and error files, %j is the job ID
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err


echo "Start time:" $( date +%s )

# Run the MPI application
# The `srun` command is Slurm's equivalent of mpirun or flux run.
# It automatically picks up the resource allocation from the SBATCH directives.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )