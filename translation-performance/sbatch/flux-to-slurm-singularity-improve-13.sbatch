#!/bin/bash
#SBATCH --job-name=amg
# This is the name of the job, useful for tracking.

#SBATCH --nodes=4
# We are requesting 4 nodes, same as the -N4 from the flux command.

#SBATCH --ntasks=256
# We are requesting 256 total MPI tasks, same as the -n 256 from the flux command.

#SBATCH --ntasks-per-node=64
# To improve performance and ensure even distribution, we specify 64 tasks per node (256 tasks / 4 nodes).

#SBATCH --exclusive
# This flag is added to ensure that our job has exclusive access to the allocated nodes,
# preventing other jobs from interfering and ensuring consistent performance.

# Load necessary modules for MPI and the high-speed network fabric.
module load openmpi
module load libfabric-aws

# Echo start time for logging purposes.
echo "Start time:" $( date +%s )

# The mpirun command launches the parallel application.
# It automatically picks up the number of nodes and tasks from the Slurm environment.
# We then execute the application inside a Singularity container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 8

# Echo end time for logging purposes.
echo "End time:" $( date +%s )