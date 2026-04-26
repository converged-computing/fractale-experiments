#!/bin/bash
#FLUX: --nodes=4
#FLUX: --ntasks=16
#FLUX: --tasks-per-node=4
#FLUX: --time-limit=1h

# NOTE: Cobalt's hardware attributes (--attrs) are not supported.
# NOTE: Cobalt's -O for output files is not supported.

#submisstion script for running tensorflow2_keras_cifar10 with horovod

echo "Running Cobalt Job $FLUX_JOB_ID."

#Loading modules

module load datascience/tensorflow-2.3

# Set environment variables that were previously passed via aprun
export OMP_NUM_THREADS=32
export KMP_BLOCKTIME=0

# aprun is replaced by flux run. Affinity settings are not translated.
flux run -n 16 python tensorflow2_keras_cifar10.py --device cpu --epochs 32 >& results/theta/tensorflow2_keras_cifar10.out 
