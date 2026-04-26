#!/bin/sh
#FLUX: --time-limit=30m
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=16
#FLUX: --job-name="pytorch-lightning-demo"
#FLUX: --output=pytorch-lightning-demo.out
#FLUX: --cwd=.


module purge
module load Anaconda3/2023.09-0
conda activate tdt4265

python trainer.py
