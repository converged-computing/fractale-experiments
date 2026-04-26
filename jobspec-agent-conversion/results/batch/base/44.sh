#!/bin/bash
#FLUX: --job-name=gnn_2_1
#FLUX: --ntasks=1
#FLUX: --time-limit=48h
#FLUX: --gpus-per-task=1
#FLUX: --requires=gpumem:32gb
#FLUX: --queue=main

# The --mem=16G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough system memory.


export PYTHONUNBUFFERED=1
module load cuda/10.2
module load anaconda
conda activate diffsub
python main.py with configs/zinc/node_del/del1_subgraph1_imle.yaml
