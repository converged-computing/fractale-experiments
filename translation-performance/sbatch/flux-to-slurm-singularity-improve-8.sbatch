#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=lammps
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

# This directive pins each MPI task to a physical CPU core.
# This is the Slurm equivalent of the flux '-o cpu-affinity=per-task' option and helps
# prevent tasks from migrating between cores, which can improve performance and reproducibility.
#SBATCH --cpu-bind=cores

# Load the required modules for MPI and the AWS Elastic Fabric Adapter (EFA)
module load openmpi libfabric-aws

# Record the start time for benchmarking
echo "Start time:" $( date +%s )

# Execute the LAMMPS simulation using mpirun and Singularity.
# mpirun will automatically pick up the node and task counts from Slurm.
# Singularity runs the application in a containerized environment.
# The --pwd flag sets the working directory inside the container to where the input data is located.
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Record the end time for benchmarking
echo "End time:" $( date +%s )