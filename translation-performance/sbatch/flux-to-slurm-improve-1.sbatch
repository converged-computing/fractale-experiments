#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128

# For performance, we calculate and set the tasks per node.
# This ensures an even distribution of work.
#SBATCH --ntasks-per-node=64

# It is good practice to name your job.
#SBATCH --job-name=lmp_reaxff_hns

# Request exclusive access to the nodes. This can improve performance
# by preventing other jobs from competing for resources.
#SBATCH --exclusive

# Distribute tasks in a cyclic manner across nodes. This can improve
# load balance for certain communication patterns.
#SBATCH --distribution=cyclic:cyclic

# Start and end time for profiling
echo "Start time:" $( date +%s )

# Run the application using srun. --mpi=pmix is added as required.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )