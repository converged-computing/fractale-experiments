#!/bin/bash

#SBATCH --job-name=llmcompr

#SBATCH --partition=ais-gpu

#SBATCH --mail-type=ALL

#SBATCH --mail-user=V.Moskvoretskii@skoltech.ru

#SBATCH --output=zh_logs/eval_lm.txt
#SBATCH --time=0-04

#SBATCH --mem=16G

#SBATCH --nodes=1

#SBATCH -c 8

#SBATCH --gpus=2

srun singularity exec --bind /trinity/home/v.moskvoretskii/:/home -f --nv /trinity/home/v.moskvoretskii/images/compression.sif bash -c '
    ls;
    cd /home;
    ls;
    export HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxx;
    export SAVING_DIR=/home/cache/;
    export HF_HOME=/home/cache/;
    export TRANSFORMERS_CACHE=/home/cache/;
    export WANDB_API_KEY=xxxxxxxxxxxxxxxxxxxxxxx;
    export CUDA_LAUNCH_BLOCKING=1;
    cd /home/LLM_Compression;
    ls;
    nvidia-smi;
    pip list;
    sh evaluate.sh;
'

