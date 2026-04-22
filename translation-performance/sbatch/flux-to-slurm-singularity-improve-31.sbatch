#!/bin/bash

#SBATCH --job-name=osu_allreduce_benchmark # Descriptive job name for easier tracking.
#SBATCH --nodes=1                          # We request 1 node, same as the original Flux '-N1' command.
#SBATCH --ntasks-per-node=64               # We request 64 tasks on that node, matching the '-n 64' and the core count of an hpc7g.6xlarge.
#SBATCH --exclusive                        # Request exclusive access to the node. This is crucial for benchmarking to prevent interference from other jobs.
#SBATCH --output=osu_allreduce_%j.out      # Standard output file, with the job ID.
#SBATCH --error=osu_allreduce_%j.err       # Standard error file, with the job ID.

# Performance Tuning:
# --cpu-bind=cores ensures that each MPI task is pinned to a specific physical core.
# This prevents the operating system from migrating tasks between cores, which can
# improve cache performance and reduce context switching overhead. This is the Slurm
# equivalent of the Flux '-o cpu-affinity=per-task' option and is critical for
# reproducible performance on HPC systems.
#SBATCH --cpu-bind=cores

# Load the required modules for MPI and the AWS EFA network fabric.
# This ensures the application uses the high-speed network for communication.
module load openmpi
module load libfabric-aws

# Echo the start time for simple profiling.
echo "Start time:" $( date +%s )

# Execute the application using srun, the native Slurm job launcher.
# srun is preferred over mpirun for tight integration with Slurm's resource management.
# The application is run inside the specified Singularity container.
srun singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Echo the end time for simple profiling.
echo "End time:" $( date +%s )