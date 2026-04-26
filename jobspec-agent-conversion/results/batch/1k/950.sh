#!/bin/bash

#FLUX: --job-name=trial_job
#FLUX: --ntasks=1
#FLUX: --cores-per-task=3
#FLUX: --time-limit=4h30m
#FLUX: --output=outputs/trial_job_%A.out


module purge
module load 2019
module load Python/3.7.5-foss-2019b
module load CUDA/10.1.243
module load cuDNN/7.6.5.32-CUDA-10.1.243
module load NCCL/2.5.6-CUDA-10.1.243
module load Anaconda3/2018.12

# cd into repo dir
cd $HOME/fact-ai/

# Activate environment
source activate fact-ai-lisa

# Run code
# srun is not required for single-process tasks
python -u main.py --model baseline --prim_hidden 64 32 --dataset LSAC --disable_warnings --num_workers 6 --no_grid_search --prim_lr 0.1 --batch_size 128 --seed_run --seed 1 --train_steps 1250

python -u main.py --model ARL --dataset LSAC --disable_warnings --num_workers 6 --no_grid_search --prim_lr 0.1 --batch_size 128 --seed_run --seed 1 --pretrain_steps 250 --train_steps 1000
