#!/bin/bash

#FLUX: --gpus-per-task=1
#FLUX: --job-name=RunAE_Normalized_Flow_Development
#FLUX: --ntasks=1
#FLUX: --cores-per-task=3
#FLUX: --time-limit=20m
#FLUX: --output=job_files/train.out


module purge
module load 2021
module load Anaconda3/2021.05

# Your job starts in the directory where you call sbatch
# Activate your environment
source activate dl2022

# Run experiments on the X-ray dataset
# These lines below indicate how to run an experiment
# srun is not required for single-process tasks
python -u train.py --dataset chest_xray --subnet_architecture resnet_like --model ae_flow --final_experiments False -fully_deterministic True --epochs 100 --seed 42 
python -u train.py --dataset chest_xray --loss_beta 0.0 --model ae_flow --final_experiments False -fully_deterministic True --epochs 100 --seed 42 
