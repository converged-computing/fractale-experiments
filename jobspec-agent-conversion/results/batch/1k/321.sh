#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16 
#FLUX: --time-limit=2h
#FLUX: --gpus-per-task=1
#FLUX: --job-name=se_fulldrop_good_ResNet4_num_blocks1x1x1x1_squeeze_and_excitation1_drop0.4
#FLUX: --output=se_fulldrop_good_ResNet4_num_blocks1x1x1x1_squeeze_and_excitation1_drop0.4.out

module load python/intel/3.8.6
module load openmpi/intel/4.0.5

source ../venvs/dl/bin/activate
time python3 main.py  --config resnet_configs/se_fulldrop_good_ResNet4.yaml --resnet_architecture se_fulldrop_good_ResNet4_num_blocks1x1x1x1_squeeze_and_excitation1_drop0.4
