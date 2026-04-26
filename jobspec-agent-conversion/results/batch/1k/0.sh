#!/bin/bash
#FLUX: --time-limit=10d
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --output=/home/zguo30/ppg_ecg_proj/ecg_only_baseline/slurm_outputs/%J.out

source /labs/hulab/stark_conda/bin/activate
conda activate base_pytorch

echo "JOB START"

nvidia-smi

python main.py
