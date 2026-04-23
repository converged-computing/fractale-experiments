#!/bin/bash
#
# Job Name: OSU Allreduce Benchmark
#
#SBATCH --job-name=osu_allreduce_benchmark

# Grant exclusive access to the nodes, ensuring that no other jobs
# run on them. This is critical for getting consistent performance results.
#SBATCH --exclusive

# Specify the number of nodes
#SBATCH --nodes=5

# Specify the total number of MPI tasks
#SBATCH --ntasks=320

# Explicitly define the number of tasks per node. This ensures a balanced
# workload across the nodes. (320 tasks / 5 nodes = 64 tasks/node)
#SBATCH --ntasks-per-node=64

# Define the output and error files. Using the job ID (%j) ensures unique filenames.
#SBATCH --output=osu_allreduce-%j.out
#SBATCH --error=osu_allreduce-%j.err

# Record the start time for profiling
echo "Start time:" $( date +%s )

# Execute the MPI benchmark using srun.
# --mpi=pmix: Use the PMIx MPI plugin as required.
# --cpu-bind=cores: Pin each MPI task to a specific CPU core. This prevents the
# operating system from migrating tasks between cores, which improves
# cache performance and reduces execution time variability.
srun --mpi=pmix --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Record the end time for profiling
echo "End time:" $( date +%s )