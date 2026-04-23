#!/bin/bash
#SBATCH --job-name=lammps_reaxff_hns
#SBATCH --nodes=3
#SBATCH --ntasks=192
#SBATCH --output=job_output_%j.out
#SBATCH --error=job_output_%j.err

# Performance Tuning Directives

# --ntasks-per-node: Explicitly setting the tasks per node can help the scheduler.
# We have 192 tasks on 3 nodes, so 64 tasks per node.
#SBATCH --ntasks-per-node=64

# --exclusive: This allocates the entire node to the job, preventing other jobs
# from interfering and ensuring all node resources (CPU, memory, network) are available.
#SBATCH --exclusive

# --cpu-bind=cores: This binds each MPI task to a specific CPU core.
# It prevents the operating system from moving tasks between cores,
# which improves performance by increasing cache efficiency.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Use srun to launch the parallel application across the allocated nodes
srun lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )