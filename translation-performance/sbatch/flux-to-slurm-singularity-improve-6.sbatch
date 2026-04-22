#!/bin/bash

#SBATCH --nodes=2
#SBATCH --ntasks=128
# This was derived from the -N2 and -n128 flags in the flux command.

#SBATCH --ntasks-per-node=64
# We have 128 tasks on 2 nodes, so we explicitly set 64 tasks per node.

#SBATCH --job-name=lammps_reaxff
# A descriptive name for the job.

#SBATCH --output=lammps_reaxff.out
#SBATCH --error=lammps_reaxff.err
# Specifying output and error files.

#SBATCH --exclusive
# This ensures the job gets exclusive access to the nodes, which is crucial for performance-sensitive MPI applications.

#SBATCH --cpu-bind=cores
# This binds each task to a physical core, which is the Slurm equivalent of flux's cpu-affinity=per-task and is optimal for performance.

#SBATCH --distribution=cyclic:cyclic
# This ensures that tasks are distributed cyclically across sockets and then nodes, which can improve performance by balancing the communication load.

# Load necessary modules for MPI and high-speed networking
module load openmpi
module load libfabric-aws

# Start timing
echo "Start time:" $( date +%s )

# Execute the lammps command within a Singularity container using mpirun
# The container and its path are specified as per the instructions.
# --pwd sets the working directory inside the container.
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# End timing
echo "End time:" $( date +%s )