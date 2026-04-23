#!/bin/bash
#
# Slurm batch script for a LAMMPS simulation
#

# -- Job Details --
# It is good practice to name your job and specify output/error files
#SBATCH --job-name=lammps_simulation
#SBATCH --output=lammps_simulation_%j.out
#SBATCH --error=lammps_simulation_%j.err

# -- Resource Allocation --
# Request 1 node, which is the direct translation of 'flux submit -N1'.
#SBATCH --nodes=1

# Request 64 total tasks, which is the direct translation of 'flux submit -n64'.
#SBATCH --ntasks=64

# Explicitly state that all 64 tasks should run on each node.
# This is redundant when --nodes=1 but adds clarity.
#SBATCH --ntasks-per-node=64

# -- Performance Enhancements --
# Request exclusive access to the node. This is crucial for performance
# as it prevents other jobs from running on the same node and causing
# resource contention (CPU, memory bandwidth, network).
#SBATCH --exclusive

# Bind tasks to specific cores. This improves performance by preventing the OS
# from migrating tasks between cores, which helps maintain CPU cache affinity.
#SBATCH --cpu-bind=cores


# -- Execution --
# Print the start time for job duration tracking
echo "Start time:" $( date +%s )

# Run the LAMMPS simulation using srun.
# The --mpi=pmix flag is added as required by the cluster configuration.
# srun will automatically use the resources allocated by the SBATCH directives above.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# Print the end time for job duration tracking
echo "End time:" $( date +%s )