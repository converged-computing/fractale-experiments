#!/bin/bash

#SBATCH --job-name=amg_job
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=64 
# This is derived from 192 tasks / 3 nodes. Matching tasks per node to the core count (hpc7g.6xlarge has 64 cores) is good for performance.
#SBATCH --output=amg_job.out
#SBATCH --error=amg_job.err
#SBATCH --cpu-bind=cores 
# This is the equivalent of flux's cpu-affinity=per-task and improves performance by pinning tasks to specific CPU cores.

# Load necessary modules for MPI and AWS EFA networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# The flux -o pmi=pmi2 is handled by the OpenMPI module and mpirun integration with Slurm.
# The executable 'amg' is mapped to the 'amg2023' singularity container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 3 8 8

echo "End time:" $( date +%s )