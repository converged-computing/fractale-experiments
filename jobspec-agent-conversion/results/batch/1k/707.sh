#!/bin/bash
#FLUX: --ntasks=2
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=10m
#FLUX: --output=gpu_accel_status.out

julia --project=test try_gpu_accel.jl > gpu_accel_print.out
