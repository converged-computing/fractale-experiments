#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --job-name=kripke
#SBATCH --output=kripke-%j.out
#SBATCH --error=kripke-%j.err

# Performance Tuning:
# We have 64 tasks on a single node. Explicitly setting tasks per node
# can help the Slurm scheduler make better placement decisions.
#SBATCH --ntasks-per-node=64

# Performance Tuning:
# Requesting exclusive access to the node ensures that no other jobs
# will run on it, preventing resource contention and providing more
# consistent performance, which is crucial for benchmarking.
#SBATCH --exclusive

# Load necessary modules for MPI and the AWS Elastic Fabric Adapter (EFA)
# This ensures the application can use the high-speed network interconnect.
module load openmpi
module load libfabric-aws

# Record start time for benchmarking
echo "Start time:" $( date +%s )

# Execute the application using mpirun.
# The application itself is run inside a Singularity container to ensure a
# consistent and reproducible software environment.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,4,4

# Record end time for benchmarking
echo "End time:" $( date +%s )