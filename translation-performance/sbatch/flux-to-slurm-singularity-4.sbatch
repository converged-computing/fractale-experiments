#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64

# Load necessary modules
module load openmpi
module load libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Run the application inside Singularity container
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Echo end time
echo "End time:" $( date +%s )