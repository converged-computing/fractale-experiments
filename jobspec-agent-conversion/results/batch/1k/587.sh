#!/bin/bash -l
#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1


# Set up software deps:
module load conda/2022-07-01
conda activate

# You have to point this to YOUR local copy of ai-science-training-series
cd /home/sryatpku/ai-science-training-series/05_dataPipelines

export TF_XLA_FLAGS="--tf_xla_auto_jit=2"
python train_resnet34.py
