#!/bin/bash
#FLUX: --job-name=resnet50
#FLUX: --ntasks=4
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=20d20h
#FLUX: --output=../outlog/out_%j.log

module load cuda/75/blas/7.5.18
module load cuda/75/fft/7.5.18
module load cuda/75/nsight/7.5.18
module load cuda/75/profiler/7.5.18
module load cuda/75/toolkit/7.5.18
module load cudnn/6.0/cuda75
module load pytorch/1.1.0

CUDA_VISIBLE_DEVICES=0,1,2,3 python3 /home/xm0036/Non-Local/cifar.py --netName=resnet50 --bs=512 --cifar=100
