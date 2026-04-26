#!/bin/sh
#FLUX: --job-name=05-resnet-adam-aug
#FLUX: -n 8
#FLUX: -N 1
#FLUX: --gpus-per-node=1
#FLUX: -t 30m
#FLUX: --output=logs/%J.out
#FLUX: --error=logs/%J.err

# The LSF directive '-R "rusage[mem=32GB]"' was omitted as it has no direct Flux translation.
# The LSF GPU mode 'exclusive_process' was omitted.
# Mail and queue directives were ignored as per instructions.

nvidia-smi
module load cuda/11.1.1

PATH=~/miniconda3/bin:$PATH

python main.py --model BaselineCNN_w_dropout --optimizer Adam --lr 0.001 --epochs 100 --augmentation 0
