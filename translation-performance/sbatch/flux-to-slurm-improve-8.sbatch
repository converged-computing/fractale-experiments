#!/bin/bash
#SBATCH --job-name=lammps_reaxff_hns
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --exclusive
#SBATCH --cpu-bind=cores
#SBATCH --output=lammps_job_%j.out
#SBATCH --error=lammps_job_%j.err

# This script is optimized for performance on clusters with high-speed interconnects.
# --exclusive: Ensures that other jobs do not run on the same nodes, reducing resource contention.
# --cpu-bind=cores: Binds each MPI task to a specific physical core, improving cache performance and reducing context switching.

echo "Start time:" $( date +%s )

# Use srun to launch the parallel application under Slurm
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )