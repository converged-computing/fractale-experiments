#!/bin/bash

# SBATCH Directives
#------------------------------------------------------------------
# Job name
#SBATCH --job-name=osu_allreduce_benchmark

# Number of nodes and tasks
# We request 4 nodes and a total of 256 tasks, which matches the original Flux command (-N4 -n 256).
#SBATCH --nodes=4
#SBATCH --ntasks=256

# For optimal performance and balanced load, we explicitly distribute the tasks
# evenly across the nodes (256 tasks / 4 nodes = 64 tasks per node).
#SBATCH --ntasks-per-node=64

# This flag requests exclusive access to the nodes. This is crucial for
# benchmarking as it prevents other jobs from interfering and ensures
# reproducible performance results.
#SBATCH --exclusive

# This is the Slurm equivalent of Flux's 'cpu-affinity=per-task'.
# It binds each MPI task to a specific CPU core, which can improve
# performance by reducing cache contention and context switching.
#SBATCH --cpu-bind=cores

# Standard output and error files using the job ID (%j) for uniqueness
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err
#------------------------------------------------------------------

echo "Start time:" $( date +%s )

# The srun command is Slurm's equivalent of mpirun or flux run.
# We add --mpi=pmix as requested by the cluster requirements.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )