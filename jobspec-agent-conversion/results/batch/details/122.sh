#!/bin/bash

#FLUX: --time-limit=30m
# The --mem=24G directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --ntasks=1


export LD_LIBRARY_PATH=/home/tysweat0/.conda/envs/img2img/lib/python3.9/site-packages/nvidia/cublas/lib

cd ~/StableComics/FullPipeline/

nvidia-smi --list-gpus
nvidia-smi --query-gpu=memory.total --format=csv

python run.py
