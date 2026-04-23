#!/bin/bash
#SBATCH --job-name=lammps_reaxff_hns
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64

# This directive improves performance by distributing tasks evenly (cyclically)
# across the allocated nodes, which can improve network locality for MPI jobs.
#SBATCH --distribution=cyclic:cyclic

# This directive improves performance by binding each MPI task to a specific CPU thread.
# This prevents the operating system from migrating tasks between CPUs, which can
# reduce cache misses and improve performance.
#SBATCH --cpu-bind=thread

# Set a descriptive output and error file name
#SBATCH --output=lammps_reaxff_hns.o%j
#SBATCH --error=lammps_reaxff_hns.e%j

echo "Start time:" $( date +%s )

# The srun command is the Slurm equivalent of mpirun or flux run
# It launches the parallel application across the allocated resources.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )