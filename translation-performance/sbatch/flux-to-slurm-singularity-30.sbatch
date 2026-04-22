#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )