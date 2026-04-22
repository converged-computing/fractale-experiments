#!/bin/bash
#
# Slurm batch script for running the AMG benchmark
#

# -- Directives specifying resource requirements --

#SBATCH --nodes=2
# This requests 2 compute nodes, same as the `-N2` in the original flux command.

#SBATCH --ntasks=128
# This requests a total of 128 MPI tasks, same as `-n 128` in flux.

#SBATCH --ntasks-per-node=64
# For optimal performance, we specify the number of tasks per node.
# hpc7g.6xlarge instances have 64 cores, so this maps one task to each physical core.

#SBATCH --job-name=amg_benchmark
# It is good practice to give the job a descriptive name.

#SBATCH --output=amg_job_%j.out
# Redirect standard output to a file named after the job ID.

#SBATCH --error=amg_job_%j.err
# Redirect standard error to a file named after the job ID.

# -- Performance-related Directives --

#SBATCH --exclusive
# This ensures that no other jobs will run on the allocated nodes, preventing resource contention.

#SBATCH --distribution=cyclic:cyclic
# This distributes tasks in a round-robin fashion across nodes and then cores.
# It can help ensure that memory access patterns are balanced, improving performance.


# --- Job Execution --- 

# 1. Load necessary modules
# The openmpi module provides the mpirun command and Slurm integration.
# The libfabric-aws module is crucial for high-speed networking with EFA.
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# 2. Run the application
echo "Starting job execution..."

echo "Start time:" $( date +%s )

# mpirun launches the application across the allocated resources.
# The command is executed within the specified Singularity container.
mpirun -np 128 /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )

echo "Job finished.