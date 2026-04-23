#!/bin/bash
#
# This script is a conversion from a Flux command to a Slurm batch job.
# The goal is to run the Kripke benchmark with high performance.

#SBATCH --job-name=kripke_job
#SBATCH --output=kripke_output.%j.log
#SBATCH --error=kripke_error.%j.log

# --nodes=2: We request 2 nodes, same as the original Flux command's -N2 flag.
#SBATCH --nodes=2

# --ntasks-per-node=64: The original command requested 128 tasks (-n 128) across 2 nodes,
# which equates to 64 tasks per node. This directive ensures an even distribution.
#SBATCH --ntasks-per-node=64

# --exclusive: This is a performance enhancement. It ensures that our job gets
# exclusive access to the allocated nodes, preventing interference from other jobs.
#SBATCH --exclusive

# --cpu-bind=cores: This is the Slurm equivalent of Flux's "-o cpu-affinity=per-task".
# It binds each task to a specific CPU core, which can improve performance by
# enhancing cache utilization and reducing task migration overhead.
#SBATCH --cpu-bind=cores

# --distribution=cyclic:cyclic: This directive controls how tasks are distributed
# across nodes and sockets. A cyclic distribution can improve performance for
# communication-intensive applications by spreading tasks out.
#SBATCH --distribution=cyclic:cyclic

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel tasks.
# We execute the original 'kripke' command with its arguments.
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,4

echo "End time:" $( date +%s )