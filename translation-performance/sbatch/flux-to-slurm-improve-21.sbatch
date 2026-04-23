#!/bin/bash
#
# Job name: Kripke benchmark
#SBATCH --job-name=kripke

# Generic Slurm Directives
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64

# Performance-Tuning Directives

# --exclusive:
# This allocates the entire node to the job, preventing other jobs from running
# on it. This reduces resource contention for memory bandwidth and cache,
# which is often beneficial for tightly-coupled HPC applications.
#SBATCH --exclusive

# --hint=nomultithread:
# This ensures that each task is bound to a physical core, preventing the use of
# simultaneous multithreading (SMT). For most HPC workloads, which are CPU-bound,
# this leads to more predictable and often better performance.
#SBATCH --hint=nomultithread

# --distribution=cyclic:cyclic:
# This directive controls how tasks are placed onto nodes and cores. 
# 'cyclic' distributes tasks in a round-robin fashion. This can improve performance 
# for applications with nearest-neighbor communication patterns by placing
# adjacent MPI ranks closer together in the network topology.
#SBATCH --distribution=cyclic:cyclic


# Standard output and error files
#SBATCH --output=kripke-%j.out
#SBATCH --error=kripke-%j.err

# Start and End Time Logging
echo "Start time:" $( date +%s )

# The application command
# We use srun to launch the parallel application.
# The --mpi=pmix flag is added as required to specify the MPI implementation.
# The application arguments from the original flux command are preserved.
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4

echo "End time:" $( date +%s )