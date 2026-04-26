#!/bin/bash
#FLUX: --job-name=hpo-mnist-lenet5
#FLUX: --nodes=4
#FLUX: --time-limit=30m
#FLUX: --output=logs/%x-%j.out

# NOTE: Flux does not support job name/ID specifiers in output paths.

##SBATCH --reservation dl4sci_sc19

module load tensorflow/intel-1.13.1-py36
module load cray-hpo

script=genetic.py
# NOTE: $SLURM_JOB_NUM_NODES is replaced by a command to get the node count from Flux.
NUM_NODES=$(flux resource list | wc -l)
args="-N ${NUM_NODES} --verbose"
path=hpo/mnist-lenet5

cd $path && python $script $args
