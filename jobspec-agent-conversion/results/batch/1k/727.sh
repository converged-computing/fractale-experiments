#!/bin/bash
GPU_COUNT=$(grep -Po "^[^\#].+gpus = \\K([0-9]+)" config.py)

#FLUX: -N 1
#FLUX: -c 12
#FLUX: --gpus-per-task=$GPU_COUNT

echo $(hostname) $CUDA_VISIBLE_DEVICES $GPU_COUNT
singularity exec /public/DL_Data/cnic_ai.img python train.py
