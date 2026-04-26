#!/usr/bin/env bash
#FLUX: --time-limit=3d
#FLUX: --output=ensemble_bal.out
#FLUX: --error=ensemble_bal.stderr
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name="ensemble bal"


source ~/.bashrc
module load cuda/10.1
conda activate vir-env
python msk_ensemble_bal.py 
