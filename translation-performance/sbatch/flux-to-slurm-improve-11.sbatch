#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=amg_job
#SBATCH --exclusive

# These sbatch options are added to improve performance.
# --exclusive: Ensures that the job has exclusive access to the nodes, 
#              preventing other jobs from causing interference.
# --ntasks-per-node: Helps the scheduler make better placement decisions.

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --cpu-bind=cores: This is a performance optimization that binds each task
#                   (MPI rank) to a specific CPU core. This can improve
#                   performance by preventing tasks from migrating between
#                   cores and improving cache utilization.
srun --cpu-bind=cores amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )