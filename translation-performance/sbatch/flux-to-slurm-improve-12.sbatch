#!/bin/bash

# Slurm Directives
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=amg_job
#SBATCH --exclusive
#SBATCH --distribution=block:block

# --nodes=3:  Request 3 nodes, same as the original Flux command's -N3.
# --ntasks=192: Request a total of 192 tasks, same as the original Flux command's -n 192.
# --ntasks-per-node=64: Explicitly specify 64 tasks per node (192 tasks / 3 nodes). This helps with process placement and can improve performance.
# --job-name=amg_job: Give the job a descriptive name.
# --exclusive: Request exclusive access to the nodes to prevent other jobs from running on the same nodes and interfering with performance.
# --distribution=block:block: Distribute tasks to nodes in blocks. This can improve performance for applications with nearest-neighbor communication patterns by placing communicating tasks closer to each other.

echo "Start time:" $( date +%s )

# The srun command is used to launch the parallel application.
# The --mpi=pmix option tells Slurm to use the PMIx library for MPI support,
# which is a modern and performant choice for process management in MPI jobs.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8

echo "End time:" $( date +%s )