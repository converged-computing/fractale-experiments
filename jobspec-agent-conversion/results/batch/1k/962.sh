#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=20h
#FLUX: --gpus-per-task=1


module purge
module load nvidia-hpc-sdk
module load gcc/8.3.0

python /scratch1/wenhuicu/brainseg/train_robust.py --loss='BCE' --beta=0.0001 --warmup=2 --class_weight=1 --suffix='_weighted_BCE'
