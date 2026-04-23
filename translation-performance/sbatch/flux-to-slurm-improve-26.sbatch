#!/bin/bash

# SBATCH --job-name=osu_allreduce_benchmark
# This provides a descriptive name for the job in the queue.

# SBATCH --nodes=1
# We are requesting one node, which directly translates from the 'flux -N1' directive.

# SBATCH --ntasks=64
# We are requesting 64 total MPI tasks, which directly translates from the 'flux -n64' directive.

# SBATCH --ntasks-per-node=64
# To ensure all tasks land on the same node.

# SBATCH --exclusive
# This flag is a performance enhancement. It grants the job exclusive access to the node,
# preventing other jobs from running concurrently and interfering with benchmark performance.


echo "Start time:" $( date +%s )

# The srun command is Slurm's equivalent of mpirun.
# --cpu-bind=cores: This is a performance enhancement that pins each MPI task to a specific CPU core.
#                   This prevents the operating system from migrating tasks, which improves cache performance and reduces execution time variance.
# --mpi=pmix: This specifies the MPI implementation to be used, as required.
srun --cpu-bind=cores --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )