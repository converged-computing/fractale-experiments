#!/bin/bash
#SBATCH --job-name=amg_job
#SBATCH --nodes=5
#SBATCH --ntasks=320

# This directive distributes tasks to nodes in a contiguous block-wise fashion.
# For MPI applications, this can improve inter-process communication performance
# by ensuring that task ranks are located physically close to each other.
#SBATCH --distribution=block:block

# This directive binds each task to a specific CPU core. This prevents the
# operating system from migrating tasks between cores, which improves cache
# performance and reduces computational jitter. It is the direct analog to
# the Flux '-o cpu-affinity=per-task' option and is a key tuning parameter.
#SBATCH --cpu-bind=cores

# Timing commands as requested
echo "Start time:" $( date +%s )

# srun is the Slurm command to launch the parallel application.
# We specify the PMI2 MPI interface to match the original Flux command.
srun --mpi=pmi2 amg -problem 2 -n 90 90 90 -P 4 8 10

# Timing commands as requested
echo "End time:" $( date +%s )