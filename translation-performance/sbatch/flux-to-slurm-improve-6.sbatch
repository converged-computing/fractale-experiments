#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=lammps_job
#SBATCH --output=lammps_%j.out
#SBATCH --error=lammps_%j.err

# Bind tasks to cores for improved performance by preventing process migration.
# This is an enhancement over the original 'cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# Request exclusive access to the nodes to prevent interference from other jobs.
# This is a performance enhancement not present in the original command.
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# Run the LAMMPS executable using srun.
# --mpi=pmix is added as per system requirements.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )