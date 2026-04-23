#!/bin/bash
#SBATCH --job-name=amg_job
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --output=amg_job.out
#SBATCH --error=amg_job.err

# Performance Tuning: Request exclusive access to the nodes.
# This prevents other jobs from running on the same nodes, ensuring that
# all node resources (memory bandwidth, network, etc.) are available to this job.
#SBATCH --exclusive

# Performance Tuning: Bind tasks to physical cores.
# This can reduce jitter and improve cache performance by preventing
# the operating system from moving tasks between cores unnecessarily.
# The original flux 'cpu-affinity=per-task' is a general request;
# '--cpu-bind=cores' is a more specific and often higher-performing choice.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# srun is used to launch the parallel application.
# The user requires --mpi=pmix for all Slurm MPI launches.
# The application 'amg' and its arguments are passed to srun for execution.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )