#!/bin/bash
#SBATCH --job-name=amg_benchmark
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --output=amg_output_%j.txt
#SBATCH --error=amg_error_%j.txt

# --cpu-bind=cores: This directive is chosen to improve performance by pinning each MPI task
# to a physical CPU core. This prevents task migration and reduces cache contention, which is
# crucial for HPC workloads. It is the Slurm equivalent of flux's '-o cpu-affinity=per-task'.
# The hpc7g.6xlarge instance type has 64 cores, so 64 tasks per node is a perfect match.
#SBATCH --cpu-bind=cores

# --exclusive: This ensures that the job gets exclusive access to the allocated nodes.
# This prevents other jobs from running on the same nodes and interfering with the benchmark,
# to ensure reproducible performance results.
#SBATCH --exclusive

echo "Start time:" $(date +%s)

# srun is the Slurm command to launch parallel tasks.
srun amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $(date +%s)