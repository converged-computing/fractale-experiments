#!/bin/bash
#SBATCH --nodes=3
#SBATCH --ntasks=192

module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )