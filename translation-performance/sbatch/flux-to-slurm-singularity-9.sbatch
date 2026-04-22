#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

module load openmpi libfabric-aws

echo "Start time:" $( date +%s )

mpirun -np 320 --bind-to core singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )