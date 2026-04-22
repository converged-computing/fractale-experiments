#!/bin/bash
#SBATCH --job-name=kripke-job
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64
#SBATCH --output=kripke-%j.out
#SBATCH --error=kripke-%j.err

# -- Improvement: Grant exclusive access to the nodes for this job.
# This prevents other jobs from running on the same nodes and interfering,
# leading to more consistent performance.
#SBATCH --exclusive

# -- Improvement: Bind each task to a specific core.
# This can improve performance by increasing cache hits and reducing overhead
# from the OS moving tasks between cores.
#SBATCH --cpu-bind=cores

# Load the required modules for MPI and AWS high-speed networking.
module load openmpi libfabric-aws

echo "Start time:" $( date +%s )

# Use mpirun to launch the application inside a Singularity container.
# Slurm's process manager integrates with MPI to correctly place the 256 tasks
# across the 4 nodes (64 tasks per node).
mpirun /shared/apps/bin/singularity exec /shared/apps/containers/fractale-agent-experiments_kripke.sif kripke --niter 100 --zones 64,64,64 --procs 4,8,8

echo "End time:" $( date +%s )