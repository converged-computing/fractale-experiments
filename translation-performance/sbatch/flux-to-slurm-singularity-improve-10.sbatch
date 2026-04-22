#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=amg
#SBATCH --output=amg-%j.out
#SBATCH --error=amg-%j.err

# Improvement: By requesting exclusive access to the node, we ensure that no other jobs
# run on it, which can prevent contention for memory bandwidth and cache, leading to
# more predictable performance.
#SBATCH --exclusive

# Load the required modules for MPI and the AWS EFA network fabric.
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Execute the application using mpirun.
# Slurm's environment variables (e.g., SLURM_NTASKS) will guide mpirun to launch the correct number of processes.
# The application itself is run inside a Singularity container as requested.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 4 4

echo "End time:" $( date +%s )