#!/bin/bash
# Execute job in the partition "lva" unless you have special requirements.
#FLUX: -q lva
# Name your job to be able to identify it later
#FLUX: --job-name=test
# Redirect output stream to this file
#FLUX: --output=output.log
# Maximum number of tasks (=processes) to start in total
#FLUX: --tasks-per-node=12
#FLUX: --nodes=1
# Enforce exclusive node allocation, do not share with other jobs
#FLUX: --exclusive

# NOTE: The SLURM partition directive '-p' was translated to the Flux queue directive '-q'.
# NOTE: The MPI launch command has been updated to use the native 'flux mini run' command.

# The OpenMPI-specific MCA parameter from the original mpirun command is now set via an environment variable.
export OMPI_MCA_fs_ufs_lock_algorithm=1
flux mini run -n 12 ./bin/saveBufferNonCollective
