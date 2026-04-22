#!/bin/bash
#
# Job Name: OSU Allreduce Benchmark
#
#SBATCH --job-name=osu_allreduce_benchmark

#SBATCH --nodes=2
# This requests 2 compute nodes, same as the Flux '-N2' argument.

#SBATCH --ntasks=128
# This requests a total of 128 MPI tasks, same as the Flux '-n 128' argument.

#SBATCH --ntasks-per-node=64
# This explicitly places 64 MPI tasks on each of the 2 nodes. On the specified
# hpc7g.6xlarge instances (64 vCPUs), this maps one task per vCPU.

#SBATCH --exclusive
# This flag is added for performance. It ensures that no other jobs can run on the
# allocated nodes, preventing resource contention for CPU, memory, and network.

# Standard output and error files
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# Load necessary modules for MPI and high-speed networking
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# Start timing
echo "Start time:" $( date +%s )

# Run the application using srun for proper Slurm integration.
# --cpu-bind=cores is the Slurm equivalent of Flux's 'cpu-affinity=per-task'.
# It pins each MPI task to a specific physical core, which is critical for performance.
echo "Running OSU Allreduce benchmark..."
srun --cpu-bind=cores singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# End timing
echo "End time:" $( date +%s )