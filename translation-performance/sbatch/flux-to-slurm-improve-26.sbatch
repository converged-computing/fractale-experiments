#!/bin/bash

# Set a descriptive job name
#SBATCH --job-name=osu_allreduce_benchmark

# Specify the number of nodes and tasks, directly translated from flux '-N1 -n64'
#SBATCH --nodes=1
#SBATCH --ntasks=64

# Direct Slurm's output and error files to include the job ID for easier tracking
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# -- Performance-related options added during conversion from Flux --

# --exclusive: Ensures the job has sole access to the node's resources,
#              preventing interference from other jobs and providing more
#              consistent performance measurements.
#SBATCH --exclusive

# --distribution=cyclic:cyclic: Distributes tasks in a round-robin fashion
#                       first across nodes, and then across sockets within a node.
#                       For single-node collective operations, this can help balance
#                       the load across the node's NUMA domains.
#SBATCH --distribution=cyclic:cyclic

# --cpu-bind=cores: Binds each task to a specific CPU core. This prevents
#                   the operating system from migrating tasks between cores,
#                   improving cache efficiency and reducing performance jitter.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Use 'srun' to launch the parallel application within the Slurm allocation.
# This is the standard way to run MPI applications under Slurm.
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )