#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=90m
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
