#!/bin/bash

# Set the job name for easier identification in the queue
#SBATCH --job-name=osu_allreduce

# Request 3 nodes, matching the original Flux request (-N3)
#SBATCH --nodes=3

# Request a total of 192 tasks, matching the original Flux request (-n 192)
#SBATCH --ntasks=192

# Explicitly distribute 64 tasks to each of the 3 nodes (192/3=64).
# This ensures a balanced workload, which is crucial for collective MPI operations.
# The hpc7g.6xlarge instances have 64 cores, so this maps one task per core.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This is a key performance enhancement,
# as it prevents other jobs from running on the same nodes and causing resource contention.
#SBATCH --exclusive

# Bind each task to a specific CPU core. This is the Slurm equivalent of flux's
# 'cpu-affinity=per-task' and is critical for preventing task migration,
# which improves cache performance and reduces jitter.
#SBATCH --cpu-bind=cores

# Load the required modules for OpenMPI and the AWS EFA networking fabric.
# This ensures the application can use the high-speed interconnect.
module load openmpi
module load libfabric-aws

# Echo the start time (epoch) for benchmarking purposes.
echo "Start time:" $( date +%s )

# Execute the application.
# mpirun is used to launch the MPI tasks as defined by the Slurm directives.
# The command is run inside the specified Singularity container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echo the end time (epoch) for benchmarking purposes.
echo "End time:" $( date +%s )