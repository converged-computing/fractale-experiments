#!/bin/bash
#
#FLUX: --gpus-per-task=  # set number of GPUs
#FLUX: --cores-per-task= # set number of CPUs per GPU
#FLUX: --job-name=multi-gpu-training
#FLUX: --output=logs/multi-gpu-training.out
#FLUX: --error=logs/multi-gpu-training.err
#FLUX: --cc=0-15

TORCH_DISTRIBUTED_DEBUG=INFO

singularity exec --pwd $(pwd) --nv \
  -B /myovision:/mnt \
  image \
  bash -c "cd /mnt/myovision-sam && torchrun --standalone --nproc_per_node=gpu train.py"

