#!/bin/bash

#SBATCH -N 1
# This requests one full node for the job.

#SBATCH -n 64
# This requests 64 tasks (MPI ranks) in total.

#SBATCH --exclusive
# This ensures the job has exclusive access to the node, preventing
# other jobs from running on it and potentially causing performance interference.
# This is a key optimization for tightly-coupled MPI applications.

#SBATCH --job-name=kripke_job
# Sets a descriptive name for the job in the queue.

#SBATCH --output=kripke_job.o%j
# Specifies the file for standard output, with the job ID (%j) appended.

#SBATCH --error=kripke_job.e%j
# Specifies the file for standard error, with the job ID (%j) appended.

echo "Start time:" $( date +%s )

# srun is used to launch the parallel application.
# --mpi=pmix: Specifies the PMIx MPI type, as required.
# --cpu-bind=cores: This is a performance optimization that pins each MPI task
# to a specific CPU core, which can improve performance by preventing process
# migration and improving cache utilization.
srun --mpi=pmix --cpu-bind=cores kripke --niter 100 --zones 64,64,64 --procs 4,4,4

echo "End time:" $( date +%s )