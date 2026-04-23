#!/bin/bash

# SBATCH --nodes=1
# This requests one node for the job, same as the original "-N1".

# SBATCH --ntasks=64
# This requests 64 total tasks, same as the original "-n 64".

# SBATCH --job-name=kripke_job
# It's good practice to give the job a descriptive name.

# SBATCH --output=kripke_job_%j.out
# Directs the standard output to a file named kripke_job_<job_id>.out.

# SBATCH --error=kripke_job_%j.err
# Directs the standard error to a file named kripke_job_<job_id>.err.

# SBATCH --exclusive
# This flag requests exclusive access to the node. Since the job utilizes all 64 cores,
# this prevents other jobs from running on the same node and causing performance interference.

# SBATCH --cpu-bind=cores
# This improves performance by pinning each MPI task to a specific physical core.
# This is the Slurm equivalent of Flux's "-o cpu-affinity=per-task" and helps
# reduce cache contention and context switching overhead.

echo "Start time:" $( date +%s )

# The srun command is Slurm's equivalent of mpirun or flux run.
# --mpi=pmix is added as requested for MPI communication.
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,4,4

echo "End time:" $( date +%s )