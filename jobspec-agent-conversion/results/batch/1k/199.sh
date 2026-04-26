#!/bin/bash
#FLUX: --job-name=gnn_2_1
#FLUX: --ntasks=1
#FLUX: --time-limit=48h
#FLUX: --gpus-per-task=1

export PYTHONUNBUFFERED=1
module load cuda/10.2
module load anaconda
conda activate diffsub
python main.py with configs/zinc/node_del/del1_subgraph1_imle.yaml
