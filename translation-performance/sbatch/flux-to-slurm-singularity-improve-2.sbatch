#!/bin/bash

# SBATCH --job-name=lammps_reaxff_hns
# This sets a descriptive name for the job in the queue.

# SBATCH --nodes=3
# We are requesting 3 nodes, directly translating the -N3 from the flux command.

# SBATCH --ntasks=192
# We are requesting 192 total MPI tasks, directly translating the -n 192 from the flux command.

# SBATCH --ntasks-per-node=64
# For performance, we explicitly state how many tasks to place on each node.
# This ensures an even distribution (192 tasks / 3 nodes = 64 tasks/node).

# SBATCH --exclusive
# This flag is added for performance. It ensures that our job gets exclusive access to the nodes,
# preventing other jobs from running on them and interfering with performance.

# SBATCH --output=slurm-lammps-%j.out
# It is good practice to specify an output file for stdout, with the job ID (%j).

# SBATCH --error=slurm-lammps-%j.err
# It is good practice to specify an error file for stderr, with the job ID (%j).

# Load necessary modules for MPI and high-speed networking
# openmpi is required for mpirun
# libfabric-aws is necessary to leverage the Elastic Fabric Adapter (EFA) for low-latency networking
module load openmpi
module load libfabric-aws

# Echo start time for benchmarking
echo "Start time:" $( date +%s )

# Execute the lammps job using mpirun
# The execution is wrapped in Singularity to use the provided container.
# The --pwd directive sets the working directory inside the container to where the application data is.
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo end time for benchmarking
echo "End time:" $( date +%s )