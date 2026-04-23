#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --job-name=lammps_reaxff

# Performance Tuning: Request exclusive access to the nodes to prevent interference
# from other jobs, which can cause performance variability.
#SBATCH --exclusive

# Performance Tuning: Distribute tasks cyclically across nodes and cores.
# This can improve load balance for certain communication patterns.
#SBATCH --distribution=cyclic:cyclic

# Performance Tuning: Bind tasks to physical cores, avoiding hyperthreads.
# This is often beneficial for compute-bound HPC workloads like this one.
#SBATCH --hint=nomultithread

# Standard output and error files, with the job ID (`%j`) in the name
#SBATCH --output=lammps_output_%j.log
#SBATCH --error=lammps_error_%j.log

echo "Start time:" $(date +%s)

# Use srun to launch the parallel application
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $(date +%s)