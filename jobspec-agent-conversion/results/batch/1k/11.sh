#!/bin/bash
#FLUX: --time-limit=1h
#FLUX: --job-name=gpt_test
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1 
#FLUX: --output=gpt_test-%J.out
#FLUX: --cores-per-task=1

module purge
# module load cuda cudnn  

# source /home/jkambulo/projects/def-rgmelko/jkambulo/py10/bin/activate
module load python/3.10

# export NCCL_BLOCKING_WAIT=1

python rydberg_rnn.py
