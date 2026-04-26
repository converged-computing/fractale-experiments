#!/bin/bash
#FLUX: --nodes=2
#FLUX: --time-limit=1h

# NOTE: Cobalt's -O for output files is not supported.

#submisstion script for running tensorflow_mnist with horovod

echo "Running Flux Job $FLUX_JOB_ID."

#Loading modules

source /lus/theta-fs0/software/thetagpu/conda/tf_master/2020-11-11/mconda3/setup.sh

# Get the number of nodes allocated to the job
JOB_SIZE=$(flux resource list | wc -l)

echo "Running job on ${JOB_SIZE} nodes"

# Assuming 8 GPUs per node as in the original script
ng=$((JOB_SIZE * 8))

if (( ${JOB_SIZE} > 1 ))
then
    # multiple nodes
    # flux run handles process placement automatically
    flux run -n $ng -N 8 python tensorflow2_mnist.py --device gpu --epochs 32 >& results/thetagpu/tensorflow2_mnist.n$ng.out
else
    # Single node
    for n in 1 2 4 8
    do
	flux run -n $n python tensorflow2_mnist.py --device gpu --epochs 32 >& results/thetagpu/tensorflow2_mnist.n$n.out
    done
fi
