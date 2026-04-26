#!/bin/bash
#FLUX: --job-name=lstmcogs
#FLUX: --time-limit=48h
#FLUX: --cores-per-task=5
#FLUX: --ntasks=1
#FLUX: --nodes=1
# The --qos=high directive is ignored.
# The --constrain=xeon-g6 directive is translated to a requirement.
#FLUX: --requires=xeon-g6
# The --gres=gpu:volta:1 directive is translated to a gpu count and a constraint.
#FLUX: --gpus-per-task=1
#FLUX: --requires=volta
# The Slurm --array directive is replaced by the --cc flag at submission time.
# This script should be submitted with: flux submit --cc=0-9 your_script_name.sh

lr=1.0
warmup_steps=4000
max_steps=8000
expname=LSTM
mkdir -p $expname
cd $expname
home="../../../"

# The Slurm array task ID is replaced with the Flux job collection variable.
i=$FLUX_JOB_CC

python -u  $home/main.py \
--seed $i \
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
--COGS > eval.$i.out 2> eval.$i.err
