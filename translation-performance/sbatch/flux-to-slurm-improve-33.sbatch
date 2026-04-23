#!/bin/bash
#
# Converted from Flux to Slurm

# --nodes=3: Request 3 nodes, same as the original Flux command (-N3).
#SBATCH --nodes=3

# --ntasks=192: Request 192 total MPI ranks, same as the original Flux command (-n 192).
#SBATCH --ntasks=192

# --ntasks-per-node=64: This is a performance optimization. By explicitly placing 64 tasks
# on each of the 3 nodes (192/3=64), we ensure the workload is perfectly balanced.
#SBATCH --ntasks-per-node=64

# --exclusive: This is a performance optimization. It ensures that no other jobs can run
# on the allocated nodes, which is critical for getting accurate and repeatable benchmark results.
#SBATCH --exclusive

# --cpu-bind=cores: This is a performance optimization and the translation for 'cpu-affinity=per-task'.
# It binds each MPI task to a specific physical CPU core, preventing task migration and ensuring
# stable performance.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --mpi=pmix: Use the PMIx MPI support, as required.
# The executable path is taken directly from the original command.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )