#!/bin/bash

#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=64
#SBATCH --exclusive

# The --exclusive flag is added to ensure that the job gets exclusive access to the nodes,
# which is crucial for accurate benchmarking by preventing interference from other jobs.

# The --ntasks-per-node is explicitly set to 64 (192 tasks / 3 nodes).
# This helps the scheduler place tasks efficiently and can improve communication performance.

# Load necessary modules for MPI and high-performance networking on AWS
module load openmpi
module load libfabric-aws

# Start timer
echo "Start time:" $( date +%s )

# Run the OSU AllReduce benchmark using mpirun with Singularity
# mpirun will use the Slurm process management interface to launch tasks across the allocated nodes.
# The application itself runs inside the specified Singularity container.
mpirun singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# End timer
echo "End time:" $( date +%s )