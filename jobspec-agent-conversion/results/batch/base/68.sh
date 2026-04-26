#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: -t 2h
#FLUX: --gpus-per-node=1
#FLUX: --job-name=se_fulldrop_good_ResNet4_num_blocks2x1x1x1_squeeze_and_excitation1_drop0
#FLUX: --output=se_fulldrop_good_ResNet4_num_blocks2x1x1x1_squeeze_and_excitation1_drop0.out

# NOTE: The Slurm directive '--mem=40GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

module load python/intel/3.8.6
module load openmpi/intel/4.0.5

source ../venvs/dl/bin/activate
time python3 main.py  --config resnet_configs/se_fulldrop_good_ResNet4.yaml --resnet_architecture se_fulldrop_good_ResNet4_num_blocks2x1x1x1_squeeze_and_excitation1_drop0
