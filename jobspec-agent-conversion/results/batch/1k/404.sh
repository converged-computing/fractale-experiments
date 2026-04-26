#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --time-limit=10m

# The Cobalt option -O for a log prefix has no direct analog.
# Redirecting output and error in the script body using Flux variables instead.
# A GPU is not explicitly requested, but the original queue name 'training-gpu' implies one is needed.

#submisstion script for running tensorflow_mnist with horovod

mkdir -p logdir

# Cobalt's -O creates separate .output and .error files. We redirect to a single .log file.
echo "Running Flux Job $FLUX_JOB_ID." > logdir/$FLUX_JOB_ID.log 2>&1


# Loading conda environment with Tensorflow
module load conda/tensorflow
conda activate

export OMP_NUM_THREADS=64
n=8
flux mini run -n $n python tensorflow2_cifar10.py --epochs 1 --logdir logdir/$FLUX_JOB_ID --num_inter $OMP_NUM_THREADS --num_intra $OMP_NUM_THREADS >> logdir/$FLUX_JOB_ID.log 2>&1
