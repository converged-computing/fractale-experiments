#!/bin/bash
#SBATCH --job-name=amg_job
#SBATCH --nodes=5
#SBATCH --ntasks=320
#SBATCH --ntasks-per-node=64
#SBATCH --output=amg_job_%j.out
#SBATCH --error=amg_job_%j.err

# Performance-oriented directives
# --cpu-bind=cores: Binds each task to a physical core. This is analogous to Flux's
# 'cpu-affinity=per-task' and is crucial for performance by preventing tasks
# from migrating between cores, which improves cache utilization.
#SBATCH --cpu-bind=cores

# --distribution=cyclic:cyclic: Distributes tasks in a round-robin fashion
# first across nodes, and then across the allocated cores on each node.
# This can improve performance for applications with specific communication
# patterns by ensuring processes are spread evenly across the network fabric.
#SBATCH --distribution=cyclic:cyclic

# Load necessary modules for MPI and high-speed networking on AWS
module load openmpi
module load libfabric-aws

# Echo start time for basic profiling
echo "Start time:" $( date +%s )

# The application will be run inside a Singularity container via mpirun.
# The executable path is inside the container.
# No --pwd flag is needed for the amg2023 application.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_amg2023.sif amg -problem 2 -n 90 90 90 -P 4 8 10

# Echo end time for basic profiling
echo "End time:" $( date +%s )