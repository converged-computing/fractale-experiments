#!/bin/bash

# Request a GPU partition node and access to 1 GPU
#FLUX: --queue=gpu
#FLUX: --gpus-per-node=1

# The --gres-flags=enforce-binding option from slurm has no direct equivalent in flux-submit.

# Ensures all allocated cores are on the same node
#FLUX: --nodes=1

# Request 1 CPU core
#FLUX: --ntasks=1

#FLUX: --time-limit=1h30m
#FLUX: --output=with_gpu.out
#FLUX: --error=with_gpu.err

# Load CUDA module
module load cuda/12.2.2  gcc/10.2   


nvidia-smi 

# Compile CUDA program and run
#nvcc -arch sm_20 vecadd.cu -o vecadd
nvcc -O2 -std=c++11 hw4.cu -o a.out
nvprof ./a.out
nsys profile ./a.out
