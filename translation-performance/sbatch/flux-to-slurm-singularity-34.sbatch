#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=osu_allreduce_benchmark

# Load necessary modules for MPI and AWS EFA networking
module load openmpi libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Run the benchmark using mpirun and Singularity
# Note: CPU affinity is not set via a directive, relying on mpirun's default behavior under Slurm.
mpirun singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echo end time
echo "End time:" $( date +%s )