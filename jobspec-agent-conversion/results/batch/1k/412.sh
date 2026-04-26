#!/bin/bash
#FLUX: --nodes=2
#FLUX: --tasks-per-node=16
#FLUX: --time-limit=5m
#FLUX: --job-name=horovod-tensorflow

# Flux jobs are typically started in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.

export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1

# The 'mpirun' command has been replaced by the standard Flux launcher 'flux mini run'.
# The number of tasks (-n 32) is calculated from the resource request (2 nodes * 16 tasks/node).
flux mini run -n 32 python3 src/tensorflow2_mnist.py
