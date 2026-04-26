#!/bin/sh
### General options
#FLUX: --job-name=TrainFullSweep
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=23h



nvidia-smi
# Load the cuda module
module load cuda/11.6
module load python3/3.9.14
source ~/env/model_env/bin/activate
python3 train_full_sweep.py
