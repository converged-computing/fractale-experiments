#!/bin/bash
#SBATCH --job-name=kripke_job
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64

# Request exclusive access to the nodes. This prevents other jobs from running on
# the same nodes and can improve performance by reducing resource contention.
#SBATCH --exclusive

# Distribute tasks in a cyclic manner across nodes and sockets. This can
# improve performance for MPI applications by balancing the communication load.
#SBATCH --distribution=cyclic:cyclic

# Bind each task to a specific CPU core. This prevents the OS from moving tasks
# between cores, which reduces cache misses and improves performance.
#SBATCH --cpu-bind=cores

echo "Start time:" $( date +%s )

# Launch the parallel application using srun. The --mpi=pmix flag is required.
srun --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4

echo "End time:" $( date +%s )