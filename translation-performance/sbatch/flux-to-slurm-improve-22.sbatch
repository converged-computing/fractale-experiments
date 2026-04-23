#!/bin/bash
#
# Slurm Batch Script for Kripke

# -- Directives from flux submit --
# SBATCH --nodes=4                # Corresponds to flux -N4
# SBATCH --ntasks=256             # Corresponds to flux -n256

# -- Job Meta-directives --
# SBATCH --job-name=kripke_job    # A descriptive name for the job
# SBATCH --output=kripke_job.out  # Standard output file
# SBATCH --error=kripke_job.err   # Standard error file

# --- Performance Tuning Directives ---

# --exclusive: This flag ensures that the job gets exclusive access to the allocated nodes.
# This is crucial for performance-sensitive applications as it prevents other jobs
# from contending for resources like CPU, memory, and network bandwidth.
#SBATCH --exclusive

# --distribution=block:block: This directive controls the distribution of tasks to nodes.
# 'block:block' distributes tasks to nodes in blocks, and within each node, tasks are also
# assigned in blocks. This can improve performance for applications with nearest-neighbor
# communication patterns by placing communicating processes close to each other.
#SBATCH --distribution=block:block

# -- Start timing
echo "Start time:" $( date +%s )

# The srun command is used to launch the parallel application.
# --mpi=pmix: As requested, this specifies the use of the PMIx MPI implementation.
# --cpu-bind=cores: This option binds each task to a specific CPU core.
# This prevents the operating system from migrating tasks between cores, which can
# improve cache performance and overall application stability.
srun --cpu-bind=cores --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,8

# -- End timing
echo "End time:" $( date +%s )