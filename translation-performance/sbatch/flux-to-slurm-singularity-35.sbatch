#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64

# Load necessary modules for MPI and AWS EFA networking
module load openmpi libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echo end time
echo "End time:" $( date +%s )