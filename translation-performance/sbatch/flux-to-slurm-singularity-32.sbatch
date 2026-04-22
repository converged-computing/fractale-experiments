#!/bin/bash

#SBATCH --job-name=osu_allreduce
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64

# Load necessary modules for MPI and AWS EFA networking
module load openmpi libfabric-aws

echo "Start time:" $( date +%s )

# Run the MPI application within a Singularity container.
# The flux '-o cpu-affinity=per-task' option is translated to '--bind-to core' for mpirun.
mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )