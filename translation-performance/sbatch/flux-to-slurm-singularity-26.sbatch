#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --job-name=osu_allreduce

# Load required modules for MPI and AWS EFA
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the benchmark within a Singularity container
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )