#!/bin/bash
#FLUX: --output=job.%j.out
#FLUX: --job-name=Unet
#FLUX: --nodes=1
#FLUX: --ntasks=6
#FLUX: --gpus-per-node=1

nvidia-smi

python3 script_train.py --datadir ../datasets/cityscapes --batch_size 4 --num_gpu 1 --losstype segment
# python deeplabv2_resnet101_cityscapes/test_cuda.py
