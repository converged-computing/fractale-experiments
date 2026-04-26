#!/bin/bash

#FLUX: --job-name=train
#FLUX: --time-limit=4h
#FLUX: --tasks-per-node=8
#FLUX: --gpus-per-node=1
#FLUX: --requires=a100-pcie-40gb

# The --mem-per-cpu=4G directive has no direct analog in the provided flux submit options.
# The --tmp=20G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

module load gcc/8.2.0 python_gpu/3.10.4 eth_proxy
pip install . src/guided-diffusion

DATA="$HOME/Latent-DIRE/data/data"
NAME="LDIRE-10k L-ResNet50"
MODEL="resnet50_latent"
python src/training.py --model $MODEL --name "$NAME" --data_dir $DATA --batch_size 256 --max_epochs 1000
