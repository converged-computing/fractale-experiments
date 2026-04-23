#!/bin/bash

#SBATCH --nodes=2                # Number of nodes requested, same as -N2 in flux.
#SBATCH --ntasks=128               # Total number of tasks for the job, same as -n128 in flux.
#SBATCH --ntasks-per-node=64       # Explicitly set 64 tasks per node (128 tasks / 2 nodes).
#SBATCH --job-name=lammps_job      # It is good practice to name the job for easier tracking.

# --- Performance Improvement Directives ---

# The --exclusive flag requests dedicated nodes for the job. This prevents
# other jobs from running on the same nodes, eliminating resource contention
# for CPU, memory, and network bandwidth, which is critical for performance.
#SBATCH --exclusive

# The --cpu-bind=cores directive pins each task to a specific CPU core.
# This improves performance by enhancing data locality (reducing cache misses) and
# minimizing task migration overhead, which is beneficial for compute-bound codes.
#SBATCH --cpu-bind=cores

# The --distribution=block:block directive controls how tasks are mapped to nodes.
# Using 'block' ensures that consecutive MPI ranks are placed on the same node,
# which can improve performance for applications with high intra-node communication.
#SBATCH --distribution=block:block

# Record the start time of the job execution.
echo "Start time:" $( date +%s )

# The srun command is Slurm's equivalent of mpirun or flux run for launching parallel tasks.
# It automatically uses the resources allocated by the SBATCH directives.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Record the end time of the job execution.
echo "End time:" $( date +%s )