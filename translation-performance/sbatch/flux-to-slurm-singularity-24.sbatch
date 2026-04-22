#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64

# Load modules for MPI and AWS EFA networking
module load openmpi libfabric-aws

echo "Start time:" $( date +%s )

# Execute the Kripke container using mpirun
mpirun -np 128 --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,4

echo "End time:" $( date +%s )