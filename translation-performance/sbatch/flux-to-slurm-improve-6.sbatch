#!/bin/bash
#
# Slurm Batch Script for LAMMPS

# -- Directives from Flux --
#SBATCH --nodes=2              # Equivalent to Flux -N2
#SBATCH --ntasks=128           # Equivalent to Flux -n128
#SBATCH --job-name=lammps_reaxff # Assign a descriptive name to the job

# -- Performance Enhancements for Slurm --
# This directive binds each task to a specific CPU core, which is the Slurm
# equivalent of Flux's `-o cpu-affinity=per-task` option. This improves
# performance by preventing task migration and maximizing CPU cache utilization.
#SBATCH --cpu-bind=cores

# This directive distributes tasks to nodes in contiguous blocks. For a job with
# 128 tasks on 2 nodes, this places 64 tasks on the first node and 64 on the
# second. This can improve inter-process communication efficiency.
#SBATCH --distribution=block:block

# This ensures that the allocated nodes are used exclusively by this job,
# preventing interference from other jobs and providing consistent performance.
#SBATCH --exclusive

# -- Job Execution --
echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel tasks. It automatically uses
# the resources defined in the #SBATCH directives above.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )