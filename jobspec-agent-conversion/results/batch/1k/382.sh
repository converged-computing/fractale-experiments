#!/bin/bash

#FLUX: --job-name=sft
#FLUX: --output=run_outputs/sft.out
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --time-limit=24h
#FLUX: --gpus-per-task=1

hostname

nvidia-smi

# module load poetry/1.5.1-GCCcore-12.3.0

# poetry shell

# poetry install

# pip install torch

python -m src.social_llama.training.sft

# accelerate launch src/social_llama/training/sft.py


