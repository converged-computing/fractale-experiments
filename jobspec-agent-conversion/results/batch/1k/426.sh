#!/bin/bash -l
#FLUX: --job-name="time_com"
#FLUX: --output=time_com.o
#FLUX: --error=time_com.e
#FLUX: --time-limit=15m
#FLUX: --nodes=4
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=4
#FLUX: --requires=gpu

module load daint-gpu
module load Julia/1.7.2-CrayGNU-21.09-cuda

export MPICH_RDMA_ENABLED_CUDA=1
export IGG_CUDAAWARE_MPI=1

flux run -n 4 bash -c 'LD_PRELOAD="/usr/lib64/libcuda.so:/usr/local/cuda/lib64/libcudart.so" julia -O3 --check-bounds=no --project=../../.. time_communication.jl'

