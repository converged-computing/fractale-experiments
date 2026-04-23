#!/bin/bash
#SBATCH --job-name=osu_allreduce          # Job name for identification
#SBATCH --nodes=2                         # Number of nodes to request, same as flux -N2
#SBATCH --ntasks=128                      # Total number of MPI tasks, same as flux -n128
#SBATCH --ntasks-per-node=64              # Number of tasks to run on each node (128 tasks / 2 nodes)
#SBATCH --output=osu_allreduce_%j.out     # Standard output log file
#SBATCH --error=osu_allreduce_%j.err      # Standard error log file

# ---
# Performance Optimization Directives
# ---

# This directive allocates the nodes exclusively to this job. This is crucial for
# benchmarking to prevent interference from other jobs and ensure repeatable results.
#SBATCH --exclusive

# This directive binds each MPI task to a specific CPU core. This prevents the OS
# from migrating tasks, which improves cache performance. It is the Slurm equivalent
# of flux's `-o cpu-affinity=per-task`.
#SBATCH --cpu-bind=cores

# Record the start time of the job's execution
echo "Start time:" $( date +%s )

# Execute the OSU AllReduce benchmark using srun, Slurm's parallel job launcher
srun /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# Record the end time of the job's execution
echo "End time:" $( date +%s )