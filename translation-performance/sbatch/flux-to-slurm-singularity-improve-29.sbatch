#!/bin/bash
#SBATCH --job-name=osu_allreduce
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH -o allreduce-out.%j
#SBATCH -e allreduce-err.%j
#
# This script is designed to optimize performance for the osu_allreduce benchmark.
# --ntasks-per-node=64: Ensures an even distribution of 256 tasks across the 4 nodes.
# --cpus-per-task=1: Binds each MPI rank to a specific CPU core to prevent resource contention.

# Load the necessary modules for MPI and the AWS EFA network fabric
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Execute the application within a Singularity container using mpirun
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )