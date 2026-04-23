#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

# Performance improvement: Distribute tasks evenly across the nodes (320 tasks / 5 nodes).
#SBATCH --ntasks-per-node=64

# Performance improvement: Bind tasks to specific CPU cores to improve cache performance.
# This is analogous to the original 'cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# Performance improvement: Request exclusive access to the nodes to prevent resource contention.
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# srun is the Slurm equivalent of flux run/submit for executing the parallel task.
# --mpi=pmix is used as requested for the MPI implementation.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 10

echo "End time:" $( date +%s )