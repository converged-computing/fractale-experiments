#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

# Load necessary modules for MPI and AWS EFA networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# The Flux '-o cpu-affinity=per-task' is translated to the '--bind-to core' option for mpirun
mpirun --bind-to core /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 10

echo "End time:" $( date +%s )