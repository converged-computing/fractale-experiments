#!/bin/bash

# SBATCH Directives
#-------------------------------------------------------------------------------
# Request 5 nodes for the job. This is a direct translation from the 'flux -N5' command.
#SBATCH --nodes=5

# Request a total of 320 tasks. This is a direct translation from the 'flux -n 320' command.
#SBATCH --ntasks=320

# Specify that each of the 5 nodes should run 64 tasks (320 tasks / 5 nodes).
# This ensures an even distribution of work and can improve performance by preventing
# task migration and ensuring resource allocation is predictable.
#SBATCH --ntasks-per-node=64

# Give the job a descriptive name for easier tracking in the queue.
#SBATCH --job-name=lammps_reaxff

# Request exclusive access to the nodes. This prevents other jobs from running on the
# same nodes, which can significantly improve performance and reproducibility by
# eliminating resource contention (CPU, memory, network bandwidth).
#SBATCH --exclusive

# Request that the allocated nodes be contiguous. For tightly-coupled MPI applications
# like LAMMPS, this can reduce network latency between tasks, especially when using
# high-performance interconnects like AWS EFA.
#SBATCH --contiguous

# Bind tasks to specific CPU cores. This prevents the operating system from migrating
# tasks between cores, which improves cache utilization and overall performance.
#SBATCH --cpu-bind=cores
#-------------------------------------------------------------------------------

# Echo the start time for benchmarking purposes.
echo "Start time:" $( date +%s )

# Run the LAMMPS simulation using srun.
# srun is Slurm's tool for launching parallel tasks. It will automatically use the
# resources allocated by the #SBATCH directives above.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo the end time for benchmarking purposes.
echo "End time:" $( date +%s )