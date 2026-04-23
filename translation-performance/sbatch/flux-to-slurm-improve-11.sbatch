#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=amg_benchmark
#SBATCH --output=amg_benchmark.out
#SBATCH --error=amg_benchmark.err

# Request exclusive access to the nodes for performance consistency
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# srun is the Slurm equivalent of mpirun/flux run
# --cpu-bind=cores pins tasks to specific CPU cores, which often improves performance
# by reducing cache misses and context switching.
# --mpi=pmix uses the PMIx library for MPI support, as requested.
srun --cpu-bind=cores --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )