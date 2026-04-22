#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --job-name=lammps_reaxff

# Load necessary modules for MPI and networking
module load openmpi
module load libfabric-aws

# Echo start time for logging
echo "Start time:" $( date +%s )

# Execute the lammps command inside a Singularity container using mpirun
mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo end time for logging
echo "End time:" $( date +%s )