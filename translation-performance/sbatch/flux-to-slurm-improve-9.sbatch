#!/bin/bash

# Set the number of nodes for the job
#SBATCH --nodes=5

# Set the total number of tasks (MPI ranks)
#SBATCH --ntasks=320

# Set the number of tasks per node. This is calculated as ntasks/nodes (320/5 = 64)
#SBATCH --ntasks-per-node=64

# Set a name for the job, which will appear in queue listings
#SBATCH --job-name=lammps_simulation

# Specify the file for standard output. %j will be replaced with the job ID.
#SBATCH --output=lammps_output_%j.log

# Specify the file for standard error. %j will be replaced with the job ID.
#SBATCH --error=lammps_error_%j.log

# IMPROVE PERFORMANCE: Request exclusive access to the nodes.
# This prevents other jobs from running on the same nodes, reducing contention
# for shared resources like memory bandwidth and network interface.
#SBATCH --exclusive

# IMPROVE PERFORMANCE: Bind tasks to cores.
# This tells Slurm to pin each task to a specific CPU core, which can improve
# performance by increasing cache hits and reducing context switching.
# This is the analogous translation for flux's '-o cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Use srun to launch the parallel application.
# The --mpi=pmix flag is specified as required for the MPI implementation.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )