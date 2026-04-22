#!/bin/bash
#SBATCH --job-name=osu_allreduce
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --output=osu_allreduce.out
#SBATCH --error=osu_allreduce.err

# Load necessary modules
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun --bind-to core singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )