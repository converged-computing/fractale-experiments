#!/bin/bash

#SBATCH --job-name=amg-benchmark
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64
#SBATCH --exclusive
#SBATCH --output=amg-%j.out
#SBATCH --error=amg-%j.err

# Performance and Distribution Comments:
# --nodes=5 and --ntasks=320 are directly translated from the flux command.
# This results in 64 tasks per node (--ntasks-per-node=64).
# --exclusive is added to ensure that the job has exclusive access to the allocated nodes,
# which prevents other jobs from interfering and ensures predictable performance.
# The default block distribution is usually sufficient for this type of application.
# The underlying Slurm configuration with EFA support should automatically select the
# optimal network fabric for MPI communications.

echo "Start time:" $( date +%s )

# The srun command executes the parallel application.
# --mpi=pmix is included as requested by the user for process management.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 10

echo "End time:" $( date +%s )