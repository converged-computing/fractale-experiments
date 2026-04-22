#!/bin/bash
#
# This script was converted from a flux command to a Slurm batch script.

# SBATCH --job-name=amg_job
# This provides a human-readable name for the job.

# SBATCH --nodes=5
# Translated from the flux -N5 flag.

# SBATCH --ntasks=320
# Translated from the flux -n 320 flag, specifying the total number of MPI ranks.

# SBATCH --ntasks-per-node=64
# Calculated from total tasks (320) and nodes (5). This ensures an even distribution of tasks.

# SBATCH --exclusive
# This directive is added to improve performance by requesting exclusive access
# to the allocated nodes, preventing interference from other jobs.

# SBATCH --distribution=cyclic:cyclic
# This directive is a performance enhancement. It distributes tasks in a round-robin fashion
# across sockets and cores, which can improve performance for communication-intensive applications.

# SBATCH --mpi=pmi2
# This is the direct translation of the flux `-o pmi=pmi2` option to ensure the correct
# process management interface is used.


# Load the necessary modules for Open MPI and AWS EFA networking support.
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# The original command 'amg -problem 2 -n 90 90 90 -P 4 8 10' is now executed
# via mpirun and wrapped in a Singularity container for portability and reproducibility.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 10

echo "End time:" $( date +%s )