#!/bin/bash

# Slurm Job Name
#SBATCH --job-name=osu_allreduce_benchmark

# Number of nodes
# This is equivalent to the -N4 option in the Flux command.
#SBATCH --nodes=4

# Total number of tasks to be launched
# This is equivalent to the -n 256 option in the Flux command.
#SBATCH --ntasks=256

# To ensure an even distribution, we specify the number of tasks per node.
# This is derived from the total tasks (256) and nodes (4).
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes
# This is crucial for performance benchmarking to prevent other jobs from
# interfering and causing performance variations.
#SBATCH --exclusive

# Standard output and error files
# Using the job ID (%j) for unique filenames is a good practice.
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

echo "Start time:" $( date +%s )

# The srun command is used to launch the parallel application.
# It inherits the resource allocation settings (--nodes, --ntasks) from sbatch.
#
# --cpu-bind=cores
# This is the Slurm equivalent for Flux's cpu-affinity=per-task. It binds each
# MPI task to a specific CPU core, which is essential for performance by
# preventing the OS from migrating tasks between cores.
#
# --distribution=cyclic:cyclic
# This option controls how tasks are distributed. 'cyclic:cyclic' distributes
# tasks in a round-robin fashion across nodes, and then cyclically across the
# sockets within each node. This can improve communication performance for
# collective operations like Allreduce by spreading the load across the
# interconnects more evenly.
srun --cpu-bind=cores --distribution=cyclic:cyclic /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )