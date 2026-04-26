#!/bin/bash
#FLUX: --output=job.{{id}}.out
#FLUX: --queue=gpulab02
#FLUX: --job-name=Unet
#FLUX: --nodes=1
#FLUX: --tasks-per-node=6
#FLUX: --gpus-per-node=1

nvidia-smi

python3 script_train.py --datadir ../datasets/cityscapes --batch_size 4 --num_gpu 1 --losstype segment
# python deeplabv2_resnet101_cityscapes/test_cuda.py
