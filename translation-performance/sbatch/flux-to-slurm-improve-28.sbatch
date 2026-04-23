#!/bin/bash
#
# Slurm batch script for osu_allreduce benchmark

# -- Directives --
#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=64

# --- Performance Tuning Directives ---

# Request exclusive access to the nodes. This is crucial for benchmarking
# to prevent other jobs from interfering with performance.
#SBATCH --exclusive

# Distribute tasks in a block fashion across nodes. This can improve
# performance for tightly-coupled MPI applications by ensuring that
# ranks are packed onto nodes, potentially improving locality.
#SBATCH --distribution=block:block

# --- Script Body ---

echo "Start time:" $( date +%s )

# Execute the benchmark using srun.
# --cpu-bind=cores: Binds each MPI task to a specific CPU core. This prevents
# task migration and improves cache performance, which is critical for
# communication-intensive benchmarks.
# --mpi=pmix: Use the PMI-Ex MPI support as required.
srun --cpu-bind=cores --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )