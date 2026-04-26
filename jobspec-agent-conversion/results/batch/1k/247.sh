#!/bin/bash

# Bede GPU submission

#FLUX: --time-limit=1h

#FLUX: --nodes=1
#FLUX: --gpus-per-node=4


module load cuda
module load Anaconda3

nvidia-smi

source activate wmlce_env

python model/main.py
