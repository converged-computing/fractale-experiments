#!/bin/bash
#
#SBATCH --job-name=lammps_reaxff_hns
# Name for the job, chosen based on the input file.

#SBATCH --nodes=3
# We are requesting 3 nodes, a direct conversion from the -N3 flag.

#SBATCH --ntasks=192
# We are requesting 192 total tasks/processes, a direct conversion from the -n 192 flag.

#SBATCH --ntasks-per-node=64
# For performance and predictable placement, we explicitly request 64 tasks per node (192 tasks / 3 nodes).

#SBATCH --exclusive
# Requesting exclusive access to the nodes to prevent other jobs from interfering, which is crucial for performance-sensitive MPI jobs.

#SBATCH --cpu-bind=cores
# This is the Slurm equivalent of flux's `-o cpu-affinity=per-task`. It binds each MPI task to a specific CPU core, which can improve performance by reducing cache contention.

# Load the required modules for OpenMPI and the AWS EFA fabric.
module load openmpi libfabric-aws

# Echo the start time (in seconds since the epoch) for benchmarking.
echo "Start time:" $( date +%s )

# Execute the lammps application via mpirun and singularity.
# The command is wrapped in singularity to run within the specified container.
# The --pwd flag sets the working directory inside the container to where the application data is located.
mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo the end time (in seconds since the epoch) for benchmarking.
echo "End time:" $( date +%s )