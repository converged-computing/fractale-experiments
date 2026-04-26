#!/bin/bash
#FLUX: --job-name=lstmcogs
#FLUX: --time-limit=48h
#FLUX: --cores-per-task=5
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --queue=high
#FLUX: --gpus-per-task=1
#FLUX: --requires="xeon-g6&volta"
#FLUX: --cc=0-9

# NOTE: This script uses the Flux job collection variable $FLUX_JOB_CC
# to replace the original script's use of $SLURM_ARRAY_TASK_ID.

lr=1.0
warmedup_steps=4000
max_steps=8000
expname=LSTM
mkdir -p $expname
cd $expname
home="../../../"

python -u  $home/main.py \
--seed $FLUX_JOB_CC \
--n_batch 128 \
--n_layers 2 \
--dim 512 \
--lr ${lr} \
--temp 1.0 \
--dropout 0.4 \
--beam_size 5 \
--gclip 5.0 \
--accum_count 4 \
--valid_steps 500 \
--warmup_steps ${warmup_steps} \
--max_step ${max_steps} \
--tolarance 10 \
--tb_dir ${expname} \
--COGS > eval.${FLUX_JOB_CC}.out 2> eval.${FLUX_JOB_CC}.err
