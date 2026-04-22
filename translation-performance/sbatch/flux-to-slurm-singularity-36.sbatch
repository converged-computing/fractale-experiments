#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=2

# Load necessary modules
module load openmpi libfabric-aws

# Echo start time
echo "Start time:" $( date +%s )

# Run the command using mpirun and Singularity
mpirun singularity exec /shared/apps/containers/fractale-agent-experiments_osu-latency.sif /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

# Echo end time
echo "End time:" $( date +%s )