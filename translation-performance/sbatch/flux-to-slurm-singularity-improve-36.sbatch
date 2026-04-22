#!/bin/bash

# Set a descriptive name for your job
#SBATCH --job-name=osu_latency_benchmark

# Request 2 nodes for the job
#SBATCH --nodes=2

# Request a total of 2 tasks for the job
#SBATCH --ntasks=2

# Ensure one task is placed on each node, which is ideal for a point-to-point latency test
#SBATCH --ntasks-per-node=1

# Specify file names for standard output and error
#SBATCH --output=osu_latency_%j.out
#SBATCH --error=osu_latency_%j.err

### Performance Tuning Directives ###

# --exclusive: This flag is critical for benchmarking. It ensures that the nodes
# allocated to this job are not shared with any other jobs, preventing resource
# contention and providing a clean environment for measuring performance.
#SBATCH --exclusive

# --distribution=cyclic:cyclic: This directive tells Slurm to distribute the tasks
# cyclically across the allocated nodes. For a 2-node, 2-task job, this guarantees
# that one task is placed on each node, which is the correct setup for a latency benchmark.
#SBATCH --distribution=cyclic:cyclic

# --cpus-per-task=1: Explicitly bind one CPU core to each task. This prevents the
# operating system from moving the task between CPU cores, which can introduce
# performance jitter and lead to less consistent measurements.
#SBATCH --cpus-per-task=1

# Load the necessary modules for MPI and AWS EFA networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Execute the OSU latency benchmark.
# mpirun will automatically pick up the resource configuration (--nodes, --ntasks) from Slurm.
# The command is executed within the specified Singularity container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-latency.sif /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

echo "End time:" $( date +%s )