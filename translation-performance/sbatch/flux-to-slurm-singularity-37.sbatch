#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --job-name=osu_latency

module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-latency.sif /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

echo "End time:" $( date +%s )