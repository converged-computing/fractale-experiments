#!/bin/bash

# SBATCH --job-name=amg_benchmark

# This requests 4 nodes, the same as the -N4 in the flux command.
#SBATCH --nodes=4

# This requests 256 total tasks, the same as -n256 in the flux command.
#SBATCH --ntasks=256

# We calculate tasks per node (256 tasks / 4 nodes = 64) for even distribution.
#SBATCH --ntasks-per-node=64

# To improve performance, we exclusively allocate the nodes to this job.
# This prevents other jobs from running on the same nodes and causing interference.
#SBATCH --exclusive

# This binds each task to a specific CPU core, which is the Slurm equivalent
# of Flux's `-o cpu-affinity=per-task`. This improves performance by
# reducing cache contention.
#SBATCH --cpu-bind=cores

# Capture start time
echo "Start time:" $( date +%s )

# Execute the application using srun.
# --mpi=pmix is added as requested for the PMI (Process Management Interface).
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8

# Capture end time
echo "End time:" $( date +%s )