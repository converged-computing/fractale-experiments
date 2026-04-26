#!/usr/bin/env zsh
#FLUX: --job-name=task2
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --output=task2.out

module load nvidia/cuda/11.8.0

nvcc task2.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task2

# Array of values
values=(1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608 16777216 33554432)

# Loop through each value and run the task
for val in "${values[@]}"; do
    ./task2 $val 512
done
