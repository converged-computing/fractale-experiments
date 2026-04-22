#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --job-name=lammps_reaxff
#SBATCH --output=lammps_reaxff_%j.out
#SBATCH --error=lammps_reaxff_%j.err

# Performance-related directives
# Distribute tasks evenly across nodes (256 tasks / 4 nodes = 64 tasks/node).
# This is a good starting point as hpc7g.6xlarge instances have 64 vCPUs, mapping one task per vCPU.
#SBATCH --ntasks-per-node=64

# Ensure exclusive access to the nodes for best performance.
#SBATCH --exclusive

# This setting can improve performance by affecting how MPI ranks are placed onto physical hardware.
# Cyclic distribution can be beneficial for communication-intensive applications.
#SBATCH --distribution=cyclic:cyclic

# Load necessary modules for MPI and high-performance networking on AWS.
module load openmpi
module load libfabric-aws

# Record start time for benchmarking.
echo "Start time:" $( date +%s )

# Execute the LAMMPS simulation within a Singularity container.
# mpirun from the loaded OpenMPI module launches the parallel job.
# The singularity exec command runs the application from the specified container image.
# --pwd sets the working directory inside the container to where the input data is located.
mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Record end time for benchmarking.
echo "End time:" $( date +%s )