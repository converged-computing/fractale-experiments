#!/bin/bash -l
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --tasks-per-node=24
#FLUX: --gpus-per-node=2

cd ~/Forest
module load python2
source activate installs
module load cuda/9.0
python play_bmsb.py
