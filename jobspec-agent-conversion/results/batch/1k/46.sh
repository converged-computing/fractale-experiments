#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=256
#FLUX: --gpus-per-task=8
#FLUX: --output=sbatch_outputs/2D_blind_dncnn_%j.out
#FLUX: --error=sbatch_outputs/2D_blind_dncnn_%j.err

source ~/modules/pytorch/latest
source ~/modules/nccl/nccl_2.9.8-1+cuda11.0_x86_64/source
PL_TORCH_DISTRIBUTED_BACKEND=nccl python train-lightning.py --config-file configs/2D/blind-denoising/dncnn.yaml
