#!/bin/bash

# Job name for easy identification
#SBATCH --job-name=amg_job

# Specify the number of nodes
# Translated from flux -N1
#SBATCH --nodes=1

# Specify the number of tasks per node. Since the original command was -n 64 on 1 node.
# Translated from flux -n 64 and -N1
#SBATCH --ntasks-per-node=64

# Request exclusive access to the node for performance.
# This prevents other jobs from running on the same node and causing interference.
# This is an added optimization.
#SBATCH --exclusive

# Bind tasks to cores for improved performance and cache utilization.
# Translated from flux -o cpu-affinity=per-task
#SBATCH --cpu-bind=cores

# Standard output and error files
#SBATCH --output=amg_output_%j.txt
#SBATCH --error=amg_error_%j.txt

# Load necessary modules for MPI and networking on AWS
module load openmpi
module load libfabric-aws

# Record the start time
echo "Start time:" $( date +%s )

# Run the application inside the singularity container using mpirun
# The container path for 'amg' is specified in the instructions.
# The application command and its arguments are passed to the container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 4 4

# Record the end time
echo "End time:" $( date +%s )