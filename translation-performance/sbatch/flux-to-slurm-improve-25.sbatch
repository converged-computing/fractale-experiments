#!/bin/bash
#
# This script was converted from a flux command.
#

# Set the job name
#SBATCH --job-name=kripke_job

# Specify the number of nodes
#SBATCH -N 4

# Specify the total number of tasks
#SBATCH -n 256

# Specify the number of tasks per node
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes for performance
# This ensures that no other jobs will run on these nodes,
# reducing contention for resources like memory bandwidth and network.
#SBATCH --exclusive

# Specify output and error files
#SBATCH -o kripke_job.o%j
#SBATCH -e kripke_job.e%j


echo "Start time:" $( date +%s )

# The srun command launches the parallel job.
# --cpu-bind=cores: This pins each MPI task to a physical core.
#                   It is the analogous and recommended performance setting for
#                   the flux '-o cpu-affinity=per-task' option.
# --distribution=cyclic:cyclic: This tells Slurm to distribute tasks in a round-robin
#                               fashion across nodes, and then across the cores on each node.
#                               This can improve performance by balancing the workload and
#                               improving communication patterns.
# --mpi=pmix: This is a required flag for the system to use the PMIx MPI library.
srun --cpu-bind=cores --distribution=cyclic:cyclic --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )