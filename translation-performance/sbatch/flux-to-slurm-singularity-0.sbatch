#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --job-name=lammps_reaxff_hns

# Load necessary modules for MPI and AWS EFA networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the lammps command inside the specified Singularity container
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )