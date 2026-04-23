#!/bin/bash
#SBATCH --job-name=lammps_job
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --output=lammps_%j.out
#SBATCH --error=lammps_%j.err

# This directive improves performance by pinning each MPI task to a specific CPU core.
# This prevents the operating system from migrating tasks between cores, which can
# reduce cache misses and improve performance for compute-intensive applications.
# It is the Slurm equivalent of Flux's '-o cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# This directive specifies how tasks are distributed across nodes and CPUs.
# For a single-node job, this ensures tasks are packed closely together,
# which can be beneficial for communication patterns, though its impact is
# more significant in multi-node jobs.
#SBATCH --distribution=block:block

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --mpi=pmix is specified as a requirement for the cluster's MPI implementation.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )