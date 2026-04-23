#!/bin/bash

#SBATCH --job-name=kripke_performance_run
#SBATCH --nodes=2
#SBATCH --ntasks=128

# This directive ensures that tasks are distributed evenly across the nodes.
# With 128 tasks and 2 nodes, this allocates 64 tasks per node.
#SBATCH --ntasks-per-node=64

# This directive allocates the nodes for exclusive use by this job,
# preventing other jobs from running on them. This can lead to more
# consistent performance for tightly-coupled MPI applications.
#SBATCH --exclusive

# Standard output and error files
#SBATCH --output=kripke_output_%j.log
#SBATCH --error=kripke_error_%j.log

# Record the start time for benchmarking
echo "Start time:" $( date +%s )

# Launch the parallel application using srun
# The --procs argument is part of the kripke application, not the workload manager.
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,4

# Record the end time for benchmarking
echo "End time:" $( date +%s )