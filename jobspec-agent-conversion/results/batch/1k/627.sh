#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --cores-per-task=10
#FLUX: --time-limit=1d
#FLUX: --output=./OUT/tabular-%j.out

# 1. Create your environement locally
module load python/3.6
module load cuda cudnn 
source ~/PPOC_gpu/bin/activate


python ./baselines/ppo1/run_mujoco.py --saves --opt=4 --minibatch=200 --dc=0.1 --tradeoff=0.01 --prew_control=1e3 --caption='' --diayn --seed=11
