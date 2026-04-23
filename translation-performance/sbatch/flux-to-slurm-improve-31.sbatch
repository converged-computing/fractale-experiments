#!/bin/bash

# Set the job name
#SBATCH --job-name=osu_allreduce_benchmark

# Request 1 node
#SBATCH --nodes=1

# Request 64 tasks (MPI ranks)
#SBATCH --ntasks=64

# Request exclusive access to the node. This is crucial for benchmarking
# to prevent interference from other jobs, leading to more consistent results.
#SBATCH --exclusive

# Bind tasks to cores. This improves performance by ensuring each MPI rank
# has a dedicated core, preventing tasks from migrating and avoiding cache contention.
#SBATCH --cpu-bind=cores

# Distribute tasks cyclically across the sockets. For a single-node job,
# this ensures tasks are spread evenly across available sockets, which can
# improve performance by maximizing memory bandwidth utilization.
#SBATCH --distribution=cyclic:cyclic

# Bind memory to the local NUMA domain. This ensures that memory allocated by a task
# comes from the memory bank physically closest to the core it is running on,
# reducing memory access latency.
#SBATCH --mem-bind=local

echo "Start time:" $(date +%s)

# Use srun to launch the MPI application. srun is Slurm's native MPI launcher
# and will correctly place the tasks according to the SBATCH directives above.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $(date +%s)