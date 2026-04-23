#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=osu_allreduce_benchmark

# This directive requests exclusive access to the nodes. For a benchmark, this is
# critical to prevent other jobs from interfering and causing performance variations.
#SBATCH --exclusive

# Standard output and error files named after the job ID
#SBATCH --output=osu_allreduce_%j.out
#SBATCH --error=osu_allreduce_%j.err

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# It automatically inherits the resource allocations from the #SBATCH directives.
# --cpu-bind=cores pins each MPI task to a specific CPU core.
# This can improve performance by increasing cache hits and preventing the OS
# from migrating tasks between cores.
srun --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )