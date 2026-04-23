#!/bin/bash

#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

# Performance-related options:
# --exclusive: Ensures that the job has sole access to the allocated nodes.
# This is critical for accurate benchmarking as it prevents interference from other jobs.
#SBATCH --exclusive

# --distribution=cyclic:cyclic: Distributes tasks in a round-robin fashion across the nodes.
# This can improve performance for certain communication patterns by ensuring tasks are spread out,
# potentially balancing network load.
#SBATCH --distribution=cyclic:cyclic

# --cpu-bind=cores: Binds each MPI task to a specific CPU core.
# This prevents the operating system from migrating tasks between cores,
# which can improve performance by enhancing cache utilization.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Run the benchmark using srun.
# --mpi=pmix is specified as required by the environment for MPI jobs.
srun --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )