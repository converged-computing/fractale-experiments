#!/bin/bash
#FLUX: --job-name="emnlp_baseline"
#FLUX: --time-limit=3d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node=1

echo "loading"
module load python/3.6.1
module load cudnn/v6
module load cuda/8.0.61
module load tensorflow/1.5.0-py36-gpu
echo "loaded"

python learn.py --num $1 --stage1 $2 --dn $3 --casing $4
