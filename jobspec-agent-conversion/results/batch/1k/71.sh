#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=12h
#FLUX: --job-name=Training_sweep_idx
#FLUX: --output=training_ouput.txt
#FLUX: --nodes=1

# Diagnostics
hostname
echo 
nvidia-smi
echo
echo CUDA_VISIBLE_DEVICES $CUDA_VISIBLE_DEVICES
echo


module load python3/anaconda/5.1.0
source activate tbenv7
wandb init -p fluxnet
wandb agent tbloch/fluxnet/4ovbzuw3
