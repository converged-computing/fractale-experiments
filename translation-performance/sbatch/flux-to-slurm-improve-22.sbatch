#!/bin/bash

# Set the job name for easier identification in the queue
#SBATCH --job-name=kripke

# Request 4 compute nodes
#SBATCH --nodes=4

# Request a total of 256 MPI tasks for the job
#SBATCH --ntasks=256

# Explicitly set the number of tasks per node. This is calculated from the
# total nodes and tasks (256 tasks / 4 nodes = 64 tasks/node) and helps
# the scheduler with placement.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This is a key performance optimization.
# It ensures that no other jobs will run on the allocated nodes, preventing
# resource contention for CPU, memory bandwidth, and the network fabric (EFA).
#SBATCH --exclusive

# Specify how tasks are distributed across the allocated nodes and sockets.
# 'cyclic' distributes tasks in a round-robin fashion over the available sockets,
# which can improve performance by balancing memory bandwidth usage.
#SBATCH --distribution=cyclic

# Define the files for standard output and error. Using the job ID (%j)
# ensures unique filenames for each run.
#SBATCH --output=kripke.%j.out
#SBATCH --error=kripke.%j.err

echo "Start time:" $( date +%s )

# Use srun to launch the parallel application. srun is Slurm's native
# job launcher and correctly propagates the resource allocation settings.
# The application command and its arguments are passed directly.
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )