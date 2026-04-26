#!/bin/bash
#FLUX: --job-name=CPSEResNet18
#FLUX: --ntasks=4
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=20d20h
#FLUX: --output=outlog/out_%j.log

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

module load cuda/75/blas/7.5.18
module load cuda/75/fft/7.5.18
module load cuda/75/nsight/7.5.18
module load cuda/75/profiler/7.5.18
module load cuda/75/toolkit/7.5.18
module load cudnn/6.0/cuda75
module load pytorch/1.0.1

CUDA_VISIBLE_DEVICES=0,1,2,3 python3 /home/xm0036/DNN/PyTorch/pytorch_cifar/cifar.py --netName=CPSEResNet18 --bs=512 --cifar=100
