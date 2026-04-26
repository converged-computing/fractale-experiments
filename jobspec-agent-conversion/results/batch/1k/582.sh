#!/bin/bash

#FLUX: --job-name=PGPR
#FLUX: --output=PGPR-%j.out
#FLUX: --error=PGPR-%j.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

module load cuda-11.2.1
module load anaconda3

# check if the GPU is present
nvidia-smi

conda activate rs_survey

python preprocess.py --dataset cd
python train_transe_model.py --dataset cd
python train_agent.py --dataset cd
python test_agent.py --dataset cd --run_path True --run_eval True
