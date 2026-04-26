#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=6
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=3d
#FLUX: --output=logs/run_train_T2_2_s20_%j.log

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

ml spconv/2.1.21-foss-2021a-CUDA-11.3.1
ml PyTorch-Geometric/2.0.2-foss-2021a-CUDA-11.3.1-PyTorch-1.10.0

cd ../..
name=T-Concord3D

python train.py --config_path 'config/semantickitti/semantickitti_T2_2_s20.yaml' \
 2>&1 | tee logs_dir/${name}_logs_tee_T2_2_s20.txt
