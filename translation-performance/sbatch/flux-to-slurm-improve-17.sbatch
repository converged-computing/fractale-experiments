#!/bin/bash
#
# Job Name: AMG benchmark
#SBATCH --job-name=amg

# We are requesting 3 nodes, same as -N3 in flux
#SBATCH --nodes=3

# We are requesting 192 total tasks, same as -n 192 in flux
#SBATCH --ntasks=192

# We calculate tasks per node to be 64 (192 tasks / 3 nodes)
# This helps Slurm to efficiently allocate resources.
#SBATCH --ntasks-per-node=64

# For performance, we request exclusive access to the nodes.
# This prevents other jobs from running on the same nodes and causing interference.
#SBATCH --exclusive

# The flux option '-o cpu-affinity=per-task' is translated to --cpu-bind=cores.
# This binds each MPI task to a physical CPU core, which is a common strategy
# to improve performance by reducing cache misses and context switching.
#SBATCH --cpu-bind=cores

# Standard output and error files
#SBATCH --output=amg.o%j
#SBATCH --error=amg.e%j

# Add timing information
echo "Start time:" $( date +%s )

# Run the application using srun. srun is Slurm's command for launching parallel jobs.
# The arguments to amg are passed directly.
srun amg -problem 2 -n 90 90 90 -P 3 8 8

# Add timing information
echo "End time:" $( date +%s )