#!/bin/bash
#FLUX: --output=job.%j.out
#FLUX: --job-name=myFirstGPUJob
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=6
#FLUX: --ntasks=6
#FLUX: --gpus-per-node=1
#FLUX: --job-name=test


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

nvidia-smi

python3 script_predict.py --datadir ../datasets/testimgs/ --num_gpu 1 --losstype segment
# python deeplabv2_resnet101_cityscapes/test_cuda.py
