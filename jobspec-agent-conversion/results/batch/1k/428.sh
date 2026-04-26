#!/bin/bash -l
#FLUX: --job-name="3D_porous_convection"
#FLUX: --output=3D_porous_convection.o
#FLUX: --error=3D_porous_convection.e
#FLUX: --time-limit=7h
#FLUX: --nodes=8
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=8
#FLUX: --requires=gpu

module load daint-gpu
module load Julia/1.7.2-CrayGNU-21.09-cuda

export MPICH_RDMA_ENABLED_CUDA=1
export IGG_CUDAAWARE_MPI=1

flux run -n 8 bash -c 'LD_PRELOAD="/usr/lib64/libcuda.so:/usr/local/cuda/lib64/libcudart.so" julia -O3 --check-bounds=no --project=../.. PorousConvection_3D_multixpu.jl'

