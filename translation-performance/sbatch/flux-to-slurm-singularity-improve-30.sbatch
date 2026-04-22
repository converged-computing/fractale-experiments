#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks=320

# This improves performance by ensuring that tasks are evenly distributed across the nodes.
# For this job, 320 tasks across 5 nodes equals 64 tasks per node.
#SBATCH --ntasks-per-node=64

# This ensures that the job gets exclusive access to the nodes,
# which is crucial for accurate and reproducible performance benchmarks.
#SBATCH --exclusive

#SBATCH --job-name=osu_allreduce_benchmark

# Load the necessary modules for MPI and the high-speed interconnect.
# OpenMPI is the MPI implementation.
# libfabric-aws is for the Elastic Fabric Adapter (EFA).
module load openmpi libfabric-aws

# Record the start time for benchmarking purposes.
echo "Start time:" $( date +%s )

# Run the OSU AllReduce benchmark using mpirun with Singularity.
# mpirun launches the MPI processes across the allocated nodes.
# The singularity command executes the benchmark inside the specified container.
# The container provides a consistent and reproducible software environment.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Record the end time.
echo "End time:" $( date +%s )