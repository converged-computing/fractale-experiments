#!/bin/bash

# Set the job name
#SBATCH --job-name=kripke

# Number of nodes and tasks
#SBATCH --nodes=1
#SBATCH --ntasks=64

# Request exclusive access to the node for performance consistency.
# This prevents other jobs from running on the same node and causing contention.
#SBATCH --exclusive

# Distribute tasks cyclically. For some applications, this can balance load
# across the node's sockets and NUMA domains, improving memory bandwidth usage.
#SBATCH --distribution=cyclic:cyclic

# Bind tasks to physical cores and disable hyper-threading. This is a common
# best practice for HPC jobs to improve cache performance.
#SBATCH --hint=nomultithread
#SBATCH --cpu-bind=cores

# Standard output and error files, using the job ID (%j) for uniqueness.
#SBATCH --output=kripke_%j.out
#SBATCH --error=kripke_%j.err

echo "Start time:" $( date +%s )

# Launch the parallel job using srun.
# The application and its arguments are passed directly.
srun kripke --niter 100 --zones 64,64,64 --procs 4,4,4

echo "End time:" $( date +%s )