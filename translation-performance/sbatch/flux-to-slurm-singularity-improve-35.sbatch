#!/bin/bash

# Slurm job directives
#-------------------------------------------------------------------------------
# Job name for easy identification
#SBATCH --job-name=osu_allreduce

# Number of nodes requested (from Flux -N5)
#SBATCH --nodes=5

# Total number of MPI tasks (from Flux -n 320)
#SBATCH --ntasks=320

# Tasks per node - calculated (320 tasks / 5 nodes = 64 tasks/node).
# This is a key parameter for performance, ensuring even distribution.
# The specified hpc7g.6xlarge instances have 64 vCPUs, so this matches the hardware.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This is crucial for benchmarking
# to prevent other jobs from interfering and causing performance variations.
#SBATCH --exclusive

# Bind tasks to cores. This improves performance by preventing task migration
# and ensuring tasks have dedicated core resources. This is the functional
# equivalent of the Flux 'cpu-affinity=per-task' option for this scenario.
#SBATCH --cpu-bind=cores

# Standard output and error files, using the job ID (%j) for uniqueness
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# Load necessary modules for MPI and AWS EFA networking
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# Record the start time for benchmarking
echo "Start time:" $( date +%s )

# Run the application using srun. 
# srun is Slurm's native job launcher and is preferred over mpirun for
# tight integration with the resource manager, which generally improves performance.
echo "Running osu_allreduce benchmark inside Singularity container..."
srun singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Record the end time for benchmarking
echo "End time:" $( date +%s )