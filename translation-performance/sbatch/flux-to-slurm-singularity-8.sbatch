#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --cpu-bind=cores

# Load necessary modules
module load openmpi libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Execute the application using mpirun and Singularity
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo end time
echo "End time:" $( date +%s )