#!/bin/bash
#
#FLUX: --job-name=JQR
#FLUX: --nodes=1
# The --mem=30GB directive has no direct flux analog and is omitted.
#FLUX: --cores-per-task=12
#FLUX: --time-limit=100h
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=4

module load python/intel/3.8.6
module load cuda/11.1.74

python3.8 -m torch.distributed.launch --nproc_per_node=4 --master_port 6666 train.py 
