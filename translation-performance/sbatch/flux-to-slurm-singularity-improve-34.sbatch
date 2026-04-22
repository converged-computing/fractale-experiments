#!/bin/bash
#
#SBATCH --job-name=osu_allreduce_benchmark
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --output=osu_allreduce.out
#SBATCH --error=osu_allreduce.err

# Performance tuning: Explicitly request 64 tasks per node to ensure even distribution.
# 256 tasks / 4 nodes = 64 tasks/node.
# hpc7g.6xlarge instances have 64 vCPUs, so this maps one MPI rank to each vCPU.
#SBATCH --ntasks-per-node=64

# Performance tuning: Request exclusive access to the nodes so that no other jobs can interfere.
#SBATCH --exclusive

# Performance tuning: Bind each task to a core. This is the direct Slurm analog to 
# flux's 'cpu-affinity=per-task' and prevents process migration, improving cache performance.
#SBATCH --cpu-bind=cores

# Load the required modules for MPI and the AWS EFA network fabric.
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the OSU AllReduce benchmark using mpirun.
# mpirun will automatically pick up the node and task information from Slurm.
# The application itself is executed within a Singularity container.
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_osu-allreduce.sif /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

echo "End time:" $( date +%s )