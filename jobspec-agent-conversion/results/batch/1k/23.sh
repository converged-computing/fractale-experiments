#!/bin/bash
#FLUX: --job-name=Falcon
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=20h
#FLUX: --requires=a100

## load environment
module purge
module load cpuarch/amd
module load anaconda-py3/2023.03
conda activate claire

## launch script on every node
set -x

MODEL=tiiuae/falcon-7b
OUTDIR=$WORK/../commun/Claire/pretrain/Claire-7B-0.1_1
mkdir -p $OUTDIR

# execute script
flux mini run python pretrain.py \
--devices 2 \
--num_nodes 1 \
--data_dir $SCRATCH/../commun/preprocessed_data/Claire/lit-gpt/padded_8_grouped/$MODEL \
--checkpoint_dir $WORK/../commun/Claire/checkpoints/$MODEL \
--language fr \
--out_dir $OUTDIR \
--precision bf16-true \
--num_epochs 1000 \
--max_checkpoints 39 \
--enable_validation true \
--save_interval 1800 \
--eval_interval 1800 \
--early_stopping 4 \
--lora_r 16 \
--lora_alpha 32 &> $OUTDIR/training_log.out
