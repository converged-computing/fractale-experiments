#!/bin/bash
#
# Job Name: LAMMPS Simulation
#
# Set the job name for easier tracking
#SBATCH --job-name=lammps_job

# Request 4 nodes
#SBATCH --nodes=4

# Request 256 total tasks
#SBATCH --ntasks=256

# Distribute 64 tasks to each of the 4 nodes
#SBATCH --ntasks-per-node=64

# This directive is a translation of flux's "-o cpu-affinity=per-task"
# It binds each task to a specific core, which often improves performance
# by reducing task migration and improving cache utilization.
#SBATCH --cpu-bind=cores

# This directive distributes tasks cyclically across nodes and then
# cyclically across sockets on each node. This can improve performance 
# for applications sensitive to network or memory bandwidth by ensuring
# tasks are spread evenly across the available hardware.
#SBATCH --distribution=cyclic:cyclic

# Specify output and error files, using the job ID (%j) for uniqueness
#SBATCH --output=lammps_%j.out
#SBATCH --error=lammps_%j.err

echo "Start time:" $( date +%s )

# The --mpi=pmix flag is added as required by the cluster configuration.
# The lmp command and its arguments are passed directly to srun for execution.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )