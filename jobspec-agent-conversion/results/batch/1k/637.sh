#!/bin/bash

# The --partition=lva directive is ignored as per instructions.
# Name your job to be able to identify it later
#FLUX: --job-name=test
# Redirect output stream to this file
#FLUX: --output=output.log
# Maximum number of tasks (=processes) to start in total
#FLUX: --tasks-per-node=12
#FLUX: --nodes=1
# Maximum number of tasks (=processes) to start per node
# Enforce exclusive node allocation, do not share with other jobs
#FLUX: --exclusive

# The mpirun command is replaced by `flux mini run`. The -np flag is not needed
# as flux will launch the correct number of tasks based on the resource specification.
flux mini run --mca fs_ufs_lock_algorithm 1 ./bin/saveBufferNonCollective
