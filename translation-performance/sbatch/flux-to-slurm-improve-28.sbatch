#!/bin/bash
#
# Slurm Batch Script for osu_allreduce benchmark

# -- CORE RESOURCE ALLOCATION --
# These directives map directly from the original flux command
#SBATCH --nodes=3                # flux -N3
#SBATCH --ntasks=192             # flux -n192
#SBATCH --job-name=osu_allreduce # It is good practice to name your job

# -- PERFORMANCE TUNING DIRECTIVES --
# The following directives were added to improve performance based on the context
# of running an MPI benchmark on a dedicated HPC cluster.

# Request exclusive access to the nodes. This is critical for benchmarking
# as it prevents other jobs from contending for CPU, memory, or network resources.
#SBATCH --exclusive

# Specify how tasks are distributed. For a collective operation like allreduce,
# cyclic distribution can help balance communication load across the network fabric
# by spreading ranks out, rather than packing them onto nodes sequentially.
#SBATCH --distribution=cyclic:cyclic

# Disable hyper-threading. Many HPC applications perform better when tasks
# are bound to physical cores, as it avoids cache contention between threads.
#SBATCH --hint=nomultithread

# -- EXECUTION --

# Per user request, echo start and end times to measure total runtime.
echo "Start time:" $( date +%s )

# Use srun to launch the parallel application. srun automatically inherits the
# resource allocations (nodes, tasks, etc.) from the SBATCH directives above.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )