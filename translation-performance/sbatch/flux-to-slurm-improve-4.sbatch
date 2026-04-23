#!/bin/bash

# Set the job name
#SBATCH --job-name=lammps_hns

# Set the number of nodes
#SBATCH --nodes=5

# Set the total number of tasks (MPI processes)
#SBATCH --ntasks=320

# Set the number of tasks per node. This is calculated from total tasks / nodes (320/5=64).
# Explicitly setting this helps the scheduler allocate resources efficiently.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes.
# This is a key performance optimization that prevents other jobs from running on the same nodes,
# eliminating contention for CPU, memory, or network resources.
#SBATCH --exclusive

# Specify the distribution of tasks to nodes and CPUs.
# 'cyclic:cyclic' distributes tasks in a round-robin fashion across nodes, and then across CPUs within each node.
# This can improve performance for communication-bound applications by spreading MPI ranks and balancing network load.
#SBATCH --distribution=cyclic:cyclic

# Bind tasks to cores.
# This locks each MPI task to a specific CPU core, preventing the OS from migrating it.
# This improves cache performance and is critical for application stability and speed.
#SBATCH --cpu-bind=cores

# Specify the output and error files. %j will be replaced with the job ID.
#SBATCH --output=lmp_output_%j.out
#SBATCH --error=lmp_error_%j.err

# Start timing
echo "Start time:" $( date +%s )

# Run the parallel application using srun.
# The --mpi=pmix flag is explicitly requested for this cluster's MPI implementation.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# End timing
echo "End time:" $( date +%s )