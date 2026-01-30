#!/bin/bash

#SBATCH --job-name=llmcompr

#SBATCH --partition=ais-gpu

#SBATCH --mail-type=ALL

#SBATCH --mail-user=V.Moskvoretskii@skoltech.ru

#SBATCH --output=zh_logs/aqlm.txt
#SBATCH --time=2-00

#SBATCH --mem=100G

#SBATCH --nodes=1

#SBATCH -c 8

#SBATCH --gpus=4

srun singularity exec --bind /trinity/home/v.moskvoretskii/:/home -f --nv /trinity/home/v.moskvoretskii/images/aqlm.sif bash -c '
    ls;
    cd /home;
    ls;
    export HF_HOME=/home/cache/;
    export HF_TOKEN=xxxxxxxxxxxxxx;
    export SAVING_DIR=/home/cache/;
    export WANDB_API_KEY=xxxxxxxxxx;
    cd /home/LLM_Compression/AQLM;
    ls;
    nvidia-smi;
    pip list;
    CUDA_LAUNCH_BLOCKING=1;
    sh quantize.sh;
'

