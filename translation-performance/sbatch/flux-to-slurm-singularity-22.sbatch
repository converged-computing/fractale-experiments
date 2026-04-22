#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256

module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )