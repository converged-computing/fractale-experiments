#!/bin/bash

#SBATCH -N 3
#SBATCH -n 192
#SBATCH --job-name=lammps_reaxff

# This directive ensures that tasks are evenly distributed across the nodes,
# with 64 tasks running on each of the 3 nodes. This can prevent imbalances
# that might degrade performance.
#SBATCH --ntasks-per-node=64

# This flag gives the job exclusive access to the allocated nodes.
# It prevents other jobs from running on the same nodes, reducing contention
# for resources like CPU, memory, and network bandwidth, leading to more
# predictable and often better performance.
#SBATCH --exclusive

# This directive binds each task to a specific CPU core. This can improve
# performance by enhancing cache utilization and reducing task migration,
# which is particularly beneficial for computationally intensive applications.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# --mpi=pmix specifies the use of the PMIx MPI implementation, as required.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )