#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 10

echo "End time:" $( date +%s )