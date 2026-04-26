#!/usr/bin/env zsh
#FLUX: --job-name=task3
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --output=task3.out


module load nvidia/cuda/11.8.0

nvcc task3.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3

./task3 65536
