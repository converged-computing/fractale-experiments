#!/bin/bash
#
# Slurm batch script for osu_latency benchmark

# -- JOB-SPECIFIC DIRECTIVES --

#SBATCH --job-name=osu_latency_benchmark
#SBATCH --nodes=2                    # Request 2 nodes, equivalent to flux -N2
#SBATCH --ntasks=2                   # Request 2 total MPI tasks, equivalent to flux -n2
#SBATCH --output=osu_latency_%j.out  # Standard output file, %j is the job ID
#SBATCH --error=osu_latency_%j.err   # Standard error file

# --- PERFORMANCE DIRECTIVES ---

#SBATCH --ntasks-per-node=1          # Place exactly one task on each node. For a point-to-point latency
                                     # test, this is critical to ensure communication goes over the network.

#SBATCH --exclusive                  # Request exclusive access to the nodes. This prevents other jobs from
                                     # running on the same nodes and creating system "noise" that could
                                     # affect latency measurements.

#SBATCH --cpus-per-task=1            # Allocate one dedicated CPU core for each task. This can help prevent
                                     # the OS from moving the process between cores, improving consistency.

# --- EXECUTABLE SECTION ---

echo "Start time:" $( date +%s )

# Use srun to launch the MPI application. Slurm automatically sets up the
# necessary environment for MPI based on the directives above.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

echo "End time:" $( date +%s )