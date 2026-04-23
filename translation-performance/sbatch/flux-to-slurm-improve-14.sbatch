#!/bin/bash

# Slurm Job Directives

# --nodes=5: Specifies the same number of nodes as the original Flux command (-N5).
#SBATCH --nodes=5

# --ntasks-per-node=64: We have 320 tasks total (-n 320) and 5 nodes, so we request 64 tasks per node.
# This helps the scheduler place the job efficiently. The hpc7g.6xlarge instances have 64 cores,
# so this maps one task to each available core.
#SBATCH --ntasks-per-node=64

# --job-name: Provides a descriptive name for the job in the queue.
#SBATCH --job-name=amg_benchmark

# --exclusive: Requests exclusive access to the allocated nodes. This is crucial for performance
# benchmarks as it prevents other jobs from interfering and causing resource contention.
#SBATCH --exclusive

# --output: Specifies the output file name, including the job ID (%j) for uniqueness.
#SBATCH --output=amg_output_%j.txt

# Start Timer
echo "Start time:" $( date +%s )

# Run the application using srun
# --cpu-bind=cores: This is a key performance optimization. It binds each MPI task to a specific CPU core,
# preventing the operating system from migrating tasks between cores. This improves cache utilization
# and reduces context switching, leading to better performance for HPC applications.
srun --cpu-bind=cores amg -problem 2 -n 90 90 90 -P 4 8 10

# End Timer
echo "End time:" $( date +%s )