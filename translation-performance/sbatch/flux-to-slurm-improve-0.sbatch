#!/bin/bash

# SBATCH Directives

# Set the job name
#SBATCH --job-name=lammps_hns

# Request 1 compute node
# This is equivalent to the -N1 in the flux command.
#SBATCH --nodes=1

# Request 64 tasks. Since we are on a single 64-core node, this allocates one task per core.
# This is equivalent to the -n 64 in the flux command.
#SBATCH --ntasks-per-node=64

# Request exclusive access to the node.
# This is a performance optimization that prevents other jobs from running on the same node,
# ensuring that your application has access to all resources (memory bandwidth, cache, etc.).
#SBATCH --exclusive

# Bind tasks to cores.
# This is another performance optimization that pins each MPI task to a specific CPU core.
# It prevents the operating system from moving tasks around, which improves cache performance.
#SBATCH --cpu-bind=cores

# Specify the output and error files. %j is replaced with the job ID.
#SBATCH --output=lammps-%j.out
#SBATCH --error=lammps-%j.err

# --- Job Execution ---

# Print the start time
echo "Start time:" $( date +%s )

# Run the lammps executable using srun.
# srun is Slurm's command for launching parallel jobs and it will automatically
# distribute the 64 tasks according to the SBATCH directives above.
# The arguments to lmp are passed directly.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Print the end time
echo "End time:" $( date +%s )