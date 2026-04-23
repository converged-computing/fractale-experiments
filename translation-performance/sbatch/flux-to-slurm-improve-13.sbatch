#!/bin/bash

#SBATCH --job-name=amg
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --output=amg-%j.out
#SBATCH --error=amg-%j.err

# Derived for performance: Calculate tasks per node for better process placement.
# 256 tasks / 4 nodes = 64 tasks per node
#SBATCH --ntasks-per-node=64

# Added for performance: Request exclusive access to the nodes to prevent
# other jobs from interfering and causing performance jitter.
#SBATCH --exclusive

# Added for performance: Use a cyclic distribution to spread tasks evenly
# across the nodes. This can improve load balancing for some applications.
#SBATCH --distribution=cyclic:cyclic

echo "Start time:" $( date +%s )

# The user requires --mpi=pmix for all srun commands.
srun --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8

echo "End time:" $( date +%s )