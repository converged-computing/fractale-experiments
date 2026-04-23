#!/bin/bash
#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This prevents other jobs from
# running on the same nodes and interfering with benchmark results.
#SBATCH --exclusive

# Use a cyclic distribution of tasks to nodes. For an all-reduce collective,
# this can help balance network traffic by spreading out consecutive ranks
# across different nodes and network links.
#SBATCH --distribution=cyclic:cyclic

echo "Start time:" $( date +%s )

srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )