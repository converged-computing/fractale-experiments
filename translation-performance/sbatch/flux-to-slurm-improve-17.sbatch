#!/bin/bash

# Slurm job options

# --nodes=3: We are requesting 3 nodes, same as the -N3 in the flux command.
#SBATCH --nodes=3

# --ntasks=192: We are requesting 192 total tasks, same as the -n 192 in the flux command.
#SBATCH --ntasks=192

# --ntasks-per-node=64: For better resource allocation and performance, we explicitly
# state that we want 64 tasks per node (192 tasks / 3 nodes).
#SBATCH --ntasks-per-node=64

# --cpu-bind=cores: This binds each task to a specific CPU core. This is the equivalent
# of flux's cpu-affinity=per-task and can significantly improve performance by
# preventing tasks from migrating between cores, which would invalidate caches.
#SBATCH --cpu-bind=cores

# --exclusive: This allocates entire nodes to the job, ensuring that no other jobs
# will run on the same nodes. This is crucial for performance-sensitive MPI
# applications to avoid resource contention.
#SBATCH --exclusive

# Set a job name for easier identification in the queue
#SBATCH --job-name=amg_benchmark

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --mpi=pmix: As requested, we are specifying the PMIx MPI type, which is a
# modern process management interface for high-performance computing.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8

echo "End time:" $( date +%s )