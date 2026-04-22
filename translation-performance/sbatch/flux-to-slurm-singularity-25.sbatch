#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64

# The Flux '-o cpu-affinity=per-task' option has no direct sbatch analog.
# We achieve similar behavior by telling the MPI runtime (mpirun) to bind each task to a core.

# Load required modules for MPI and networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the application using mpirun and Singularity
mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )