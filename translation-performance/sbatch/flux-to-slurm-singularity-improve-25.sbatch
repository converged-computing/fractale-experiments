#!/bin/bash
#
# Slurm batch script for Kripke

# Job name
#SBATCH --job-name=kripke_job

# Number of nodes
#SBATCH --nodes=4

# Number of tasks (processes)
#SBATCH --ntasks=256

# To improve performance, we request exclusive access to the nodes.
# This prevents other jobs from running on the same nodes and causing contention.
#SBATCH --exclusive

# We translate flux's 'cpu-affinity=per-task' to '--cpu-bind=rank' in Slurm.
# This binds each MPI rank to a specific CPU core, which can improve performance
# by increasing cache efficiency and reducing context switching.
#SBATCH --cpu-bind=rank

# Load the required modules for MPI and AWS networking
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Execute the kripke application within a Singularity container using mpirun
# The container path is specified as per the instructions.
mpirun singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )