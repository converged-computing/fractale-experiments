#!/bin/bash
#
# This script was converted from a Flux command.

# Slurm Directives
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --output=osu_allreduce-%j.out
#SBATCH --error=osu_allreduce-%j.err

# Performance Tuning Directives
# --exclusive: Ensures this job has sole use of the nodes for consistent performance.
#SBATCH --exclusive
# --cpu-bind=cores: Binds each MPI task to a specific physical core.
# This prevents tasks from migrating between cores, improving cache performance.
# It is the recommended analog for flux's 'cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores


# Run the benchmark
echo "Start time:" $( date +%s )

srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )