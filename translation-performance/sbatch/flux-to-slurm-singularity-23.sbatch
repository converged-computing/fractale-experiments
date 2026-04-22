#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --ntasks-per-node=64

# Load necessary modules for MPI and high-speed networking
module load openmpi libfabric-aws

# Echo start time for logging
echo "Start time:" $( date +%s )

# Execute the application within a Singularity container using mpirun
# The --bind-to core option is analogous to Flux's cpu-affinity=per-task
mpirun --bind-to core -n 64 /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,4,4

# Echo end time for logging
echo "End time:" $( date +%s )