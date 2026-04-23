#!/bin/bash
#SBATCH --job-name=amg_benchmark
#SBATCH --nodes=4
#SBATCH --ntasks=256

# Performance and Distribution Directives

# We have 256 tasks on 4 nodes, so we explicitly ask for 64 tasks per node.
# This ensures an even distribution.
#SBATCH --ntasks-per-node=64

# Distributes tasks cyclically across nodes and then cyclically across cores on each node.
# This can improve performance for applications with communication imbalances by spreading ranks across the network fabric (like EFA).
#SBATCH --distribution=cyclic:cyclic

# Bind each task to a single CPU core. This prevents tasks from migrating between cores,
# which can improve cache performance and reduce jitter.
#SBATCH --cpus-per-task=1

# Specifies the use of the PMI2 interface for MPI, matching the original Flux command.
# This ensures compatibility with the MPI library being used if it requires PMI2.
#SBATCH --mpi=pmi2

echo "Start time:" $( date +%s )

# The srun command launches the parallel application across the allocated resources.
srun amg -problem 2 -n 90 90 90 -P 4 8 8

echo "End time:" $( date +%s )