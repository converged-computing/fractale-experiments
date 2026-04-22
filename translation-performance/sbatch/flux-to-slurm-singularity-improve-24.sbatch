#!/bin/bash
#SBATCH --job-name=kripke_run
#SBATCH --output=kripke_run.o%j
#SBATCH --error=kripke_run.e%j

#SBATCH --nodes=2
# This requests 2 compute nodes, same as -N2 in the flux command.

#SBATCH --ntasks=128
# This requests 128 total MPI tasks, same as -n 128 in the flux command.

#SBATCH --ntasks-per-node=64
# For performance, we explicitly tell Slurm to distribute the 128 tasks evenly
# across the 2 nodes. This ensures balanced load.

#SBATCH --cpu-bind=cores
# This is the Slurm equivalent of flux's '-o cpu-affinity=per-task'.
# It binds each MPI task to a specific CPU core, which prevents tasks from
# migrating between cores and can improve performance by increasing cache efficiency.

# Load necessary modules for MPI and high-speed networking
module load openmpi libfabric-aws

# Echo start time for benchmarking
echo "Start time:" $( date +%s )

# Run the application using mpirun
# mpirun will automatically use the resources allocated by Slurm.
# The original kripke command is executed inside the specified Singularity container.
mpirun singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,4

# Echo end time for benchmarking
echo "End time:" $( date +%s )