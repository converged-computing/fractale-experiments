#!/usr/bin/env bash
#FLUX: --job-name=Latte-ffs
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=8
#FLUX: --ntasks=8
#FLUX: --gpus-per-node=8
#FLUX: --cores-per-task=16
#FLUX: --time-limit=20d20h
#FLUX: --output=slurm_log/%j.out 
#FLUX: --error=slurm_log/%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

source ~/.bashrc

conda activate latte

# 'srun' is replaced with 'flux run'
flux run -n 8 python train.py --config ./configs/taichi/taichi_train.yaml
