#!/bin/bash

# SBATCH DIRECTIVES
#--------------------

# Set the name of the job for identification
#SBATCH --job-name=lammps

# Request 5 nodes for this job
#SBATCH --nodes=5

# Request a total of 320 tasks (MPI processes)
#SBATCH --ntasks=320

# Calculate and specify tasks per node (320 tasks / 5 nodes = 64)
# This helps the scheduler optimize placement and can improve performance.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This is a key performance enhancement
# as it prevents other jobs from running on the same nodes and causing contention
# for CPU, memory, or network resources.
#SBATCH --exclusive

# Define output and error file names, using the job ID (%j) for uniqueness
#SBATCH --output=lammps-%j.out
#SBATCH --error=lammps-%j.err

#--------------------
# JOB SCRIPT
#--------------------

# Load the required modules for OpenMPI and AWS EFA networking
echo "Loading modules..."
module load openmpi libfabric-aws

# Echo start time for basic profiling
echo "Start time:" $( date +%s )

# Execute the LAMMPS simulation.
# 'mpirun' starts the parallel job across the allocated resources.
# 'singularity exec' runs the command within the specified container.
# The '--pwd' flag sets the correct working directory inside the container for LAMMPS.
echo "Starting LAMMPS simulation via Singularity..."
mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo end time for basic profiling
echo "End time:" $( date +%s )