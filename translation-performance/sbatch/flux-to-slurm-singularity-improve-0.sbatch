#!/bin/bash

# Job Details
#SBATCH --job-name=lammps_reaxff  # A descriptive name for your job
#SBATCH --output=lammps_%j.out   # Standard output file
#SBATCH --error=lammps_%j.err    # Standard error file

# Resource Allocation
# We are requesting 1 full node, with 64 tasks. This matches the original flux command.
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --ntasks-per-node=64 # Ensures all 64 tasks are placed on the single node

# Performance Optimizations
# --exclusive ensures that this job has the entire node to itself, preventing
# interference from other jobs, which is crucial for performance-sensitive HPC tasks.
#SBATCH --exclusive

# By binding tasks to specific CPU cores, we can improve performance by reducing
# context switching and improving cache utilization.
#SBATCH --cpu-bind=cores

# Load necessary modules for MPI and networking
# OpenMPI is required for mpirun, and libfabric-aws is needed for EFA support.
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# Start timer
echo "Start time:" $(date +%s)

# Run the LAMMPS simulation using mpirun and Singularity
# -np 64 specifies the number of processes for MPI.
# The singularity exec command runs the lmp executable from within the container.
# --pwd sets the working directory inside the container to where the input data is located.
echo "Running LAMMPS simulation..."
mpirun -np 64 singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# End timer
echo "End time:" $(date +%s)

echo "Job finished."