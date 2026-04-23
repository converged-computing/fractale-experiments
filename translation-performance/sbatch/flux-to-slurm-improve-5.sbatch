#!/bin/bash
#SBATCH --job-name=lammps_job      # Give the job a descriptive name
#SBATCH --nodes=1                  # Request 1 node, equivalent to flux's -N1
#SBATCH --ntasks=64                # Request 64 MPI tasks, equivalent to flux's -n64
#SBATCH --output=lammps_job.o%j    # Standard output file
#SBATCH --error=lammps_job.e%j     # Standard error file

# Performance Improvement:
# Bind tasks to specific cores. This prevents the operating system from moving tasks
# between cores, which can improve performance by increasing cache hits.
# This is the Slurm equivalent of flux's '-o cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# Performance Improvement:
# Request exclusive access to the node. This ensures no other jobs will run on the
# node, preventing resource contention for CPU, memory bandwidth, and network,
# leading to more predictable and often better performance for tightly-coupled MPI jobs.
#SBATCH --exclusive

echo "Start time:" $( date +%s )

# The 'srun' command is Slurm's parallel job launcher.
# It automatically reads the #SBATCH directives above to configure the environment.
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )