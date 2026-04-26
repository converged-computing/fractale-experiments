#!/bin/bash

#FLUX: --job-name="train"
#FLUX: --output="slurm_logs/train.%j.out"
#FLUX: --error="slurm_logs/train.%j.err"
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --time=2d


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

nvidia-smi
source ~/.bashrc
export WANDB_API_KEY=6503c82b63d216d89775a9c56d0a24fb8fd19580
python train.py
