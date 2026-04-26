#!/bin/bash

#FLUX: --job-name=example
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5m
#FLUX: --output=example.out

module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 PyTorch/1.10.0 tqdm/4.56.2

myworkspace="$(ws_find myworkspace)"

python "$myworkspace"/src/myscript.py
