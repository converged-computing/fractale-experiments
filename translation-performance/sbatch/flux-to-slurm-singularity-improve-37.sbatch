#!/bin/bash
#
# Job name (for identification)
#SBATCH --job-name=osu_latency_benchmark

# Resources requested
#SBATCH -N 2         # Total number of nodes to use
#SBATCH -n 2         # Total number of tasks to run
#SBATCH --ntasks-per-node=1 # Ensure one task is placed on each node for the latency test

# Performance-oriented directives
# Request exclusive access to the nodes, preventing other jobs from running
# and interfering with benchmark results.
#SBATCH --exclusive

# Pin the MPI task to a specific core. This prevents the OS from migrating the
# process between cores, which can introduce performance jitter.
#SBATCH --cpu-bind=cores

# Disable hyper-threading for the job. For many HPC applications, this improves
# performance by giving each task a full physical core.
#SBATCH --hint=nomultithread

# Standard output and error files
#SBATCH --output=osu_latency_%j.out
#SBATCH --error=osu_latency_%j.err

# Load necessary modules for MPI and high-speed networking
module load openmpi libfabric-aws

# Echo start time for monitoring
echo "Start time:" $( date +%s )

# Run the osu_latency benchmark using mpirun
# The application is executed inside a Singularity container as requested.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-latency.sif /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

# Echo end time for monitoring
echo "End time:" $( date +%s )