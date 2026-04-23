#!/bin/bash

# Slurm Job Options
#
# Job Name: A descriptive name for your job
#SBATCH --job-name=lammps_simulation
#
# Output file: Where to save the job's standard output. %j is the job ID.
#SBATCH --output=lammps_output_%j.log
#
# Number of nodes: Matches the -N3 from the flux command.
#SBATCH --nodes=3
#
# Number of tasks per node: Calculated from the total tasks (192) and nodes (3).
# This ensures an even distribution of 64 tasks on each node.
#SBATCH --ntasks-per-node=64
#
# Exclusive access: Requests exclusive access to the nodes. This prevents other jobs
# from running on the same nodes, which is crucial for performance-sensitive applications.
#SBATCH --exclusive
#
# CPU Binding: Pins each task to a specific CPU core. This is analogous to flux's
# '-o cpu-affinity=per-task' and improves performance by enhancing cache efficiency.
#SBATCH --cpu-bind=cores
#
# Task Distribution: Specifies a cyclic distribution of tasks to nodes.
# For applications with nearest-neighbor communication patterns like LAMMPS,
# this can improve performance by balancing communication load across the network fabric.
#SBATCH --distribution=cyclic:cyclic

echo "Start time:" $( date +%s )

# The srun command is Slurm's parallel job launcher.
# It automatically uses the resources allocated by the SBATCH directives above.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )