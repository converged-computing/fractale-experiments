#!/bin/bash

# SBATCH --job-name=kripke_job
# This sets a descriptive name for the job in the queue.

# SBATCH --nodes=4
# We request 4 nodes, same as the -N4 in the flux command.

# SBATCH --ntasks=256
# We request 256 total MPI ranks, same as the -n 256 in the flux command.

# SBATCH --ntasks-per-node=64
# This is derived (256 tasks / 4 nodes) to ensure even distribution.
# The hpc7g.6xlarge has 64 physical cores, so this assigns one task per core.

# SBATCH --exclusive
# This ensures that our job gets exclusive access to the allocated nodes,
# preventing other jobs from causing performance interference. This is a performance improvement.

# SBATCH --cpu-bind=cores
# This binds each MPI task to a specific physical core. This is the Slurm equivalent of
# flux's `-o cpu-affinity=per-task` and is critical for performance and reproducibility.

echo "Start time:" $( date +%s )

# The srun command is Slurm's way to launch parallel tasks.
# It automatically picks up the resource allocation from the #SBATCH directives.
srun kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )