#!/bin/bash
#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --output=osu_allreduce-%j.out
#SBATCH --error=osu_allreduce-%j.err

# Performance-enhancing directives added based on instructions.
# --exclusive: Ensures the job runs alone on the node for consistent performance.
# --cpu-bind=cores: Binds each MPI task to a specific CPU core to improve cache performance.
# --ntasks-per-node=64: Explicitly assigns all tasks to the single requested node.
#SBATCH --exclusive
#SBATCH --cpu-bind=cores
#SBATCH --ntasks-per-node=64

# Load necessary modules for MPI and high-speed networking on AWS.
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# Start timestamp
echo "Start time:" $( date +%s )

# Execute the benchmark within a Singularity container using mpirun
# The -np flag is technically redundant as Slurm exports the SLURM_NTASKS variable,
# but it is included for clarity.
echo "Running osu_allreduce benchmark..."
mpirun -np 64 /shared/apps/bin/singularity exec \
    /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif \
    /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

# End timestamp
echo "End time:" $( date +%s )