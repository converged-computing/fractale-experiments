#!/bin/bash
#FLUX: --queue=production
#FLUX: --requires="(gpu_model!=NO)&(cluster=grele)"
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --cores-per-task=2
#FLUX: --ntasks=1
#FLUX: --time-limit=1h
#FLUX: --output=./OUT/oar_job.{id}.output
#FLUX: --error=./OUT/oar_job.{id}.error

# This is to activate a python environment with conda
source ~/.bashrc

conda activate se

# Set variables
SEGMENT="$1"
CKPT_PATH="../../pretrained_models/A-VAE/A-VAE.pt"
ALGO_TYPE="peem"
DATA_DIR="/srv/storage/talc@storage4.nancy.grid5000.fr/multispeech/corpus/audio_visual/TCD-TIMIT/test_data_NTCD/test_data_5.pkl"
SAVE_ROOT="./results/"

# Run command
python SE_evaluation.py \
    --segment "$SEGMENT" \
    --ckpt_path "$CKPT_PATH" \
    --algo_type "$ALGO_TYPE" \
    --data_dir "$DATA_DIR" \
    --save_root "$SAVE_ROOT"
