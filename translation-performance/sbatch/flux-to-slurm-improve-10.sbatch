#!/bin/bash
#SBATCH --job-name=amg_benchmark
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --output=amg_output_%j.txt
#SBATCH --error=amg_error_%j.txt

# This directive ensures the job has the entire node to itself,
# preventing interference from other jobs and ensuring consistent performance.
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --mpi=pmix: Use the PMIx MPI plugin for process management, as requested.
# --cpu-bind=cores: Binds each task to a specific CPU core. This improves performance by
# preventing the operating system from moving tasks between cores, which helps keep data in the CPU cache.
# --distribution=block:block: Distributes tasks to nodes and CPUs in contiguous blocks,
# which can improve communication performance for tightly-coupled applications.
srun --mpi=pmix --cpu-bind=cores --distribution=block:block amg -problem 2 -n 90 90 90 -P 4 4 4

echo "End time:" $( date +%s )