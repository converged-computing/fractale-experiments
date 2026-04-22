#!/bin/bash

# Slurm job directives
# These settings are derived from the original Flux command: -N5 -n 320
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=lammps_reaxff
#SBATCH --output=lammps_%j.out
#SBATCH --error=lammps_%j.err

# --- Performance-related options ---
# --exclusive: This is a key performance enhancement. It ensures that our job gets exclusive
# access to the allocated nodes, preventing any other jobs from running on them and
# causing resource contention (CPU, memory, network), which leads to more consistent performance.
#SBATCH --exclusive

# --- Environment Setup ---
# Load the necessary modules. openmpi is required for mpirun, and libfabric-aws
# is essential for enabling high-speed networking with AWS Elastic Fabric Adapter (EFA).
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# --- Execution ---
# Record the start time for benchmarking.
echo "Start time:" $( date +%s )

echo "Running LAMMPS simulation..."
# We use mpirun to launch the parallel application across the allocated nodes.
# --bind-to core: This option is the Slurm/OpenMPI equivalent of the original Flux
# '-o cpu-affinity=per-task'. It pins each MPI process to a specific CPU core.
# This is crucial for performance as it prevents the operating system from moving
# tasks between cores, which would invalidate caches and decrease performance.
# The rest of the command executes the lmp binary within the specified Singularity container.
mpirun --bind-to core \
    /shared/apps/bin/singularity exec --pwd /opt/lammps-reax \
    /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif \
    lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Record the end time for benchmarking.
echo "End time:" $( date +%s )

echo "Job finished."