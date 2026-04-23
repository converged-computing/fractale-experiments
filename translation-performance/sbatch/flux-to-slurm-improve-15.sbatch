#!/bin/bash

# SBATCH directives are Slurm's way of specifying job requirements.

# Request 1 node.
#SBATCH --nodes=1

# Request 64 tasks (processes).
#SBATCH --ntasks=64

# Request exclusive access to the node. This is a performance optimization
# to prevent other jobs from interfering with this one, ensuring consistent
# performance benchmarks.
#SBATCH --exclusive

# Bind tasks to specific CPU cores. This improves performance by reducing
# CPU context switching and improving cache efficiency. This is the Slurm
# equivalent of Flux's '-o cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# Specify the PMI2 MPI process management interface, matching the original Flux command.
#SBATCH --mpi=pmi2

# --- Job Execution ---

echo "Start time:" $( date +%s )

# srun is the command to launch parallel tasks under Slurm.
# It inherits the settings from the #SBATCH directives above.
srun amg -problem 2 -n 90 90 90 -P 4 4 4

echo "End time:" $( date +%s )