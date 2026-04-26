#!/bin/bash
#FLUX: --job-name=fasttranslate
#FLUX: --time-limit=2d
#FLUX: --cores-per-task=5
#FLUX: --ntasks-per-node=1
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1



align="intersect"
lr=1.0
warmup_steps=4000
max_steps=8000
expname=fast_${align}
mkdir -p $expname
cd $expname
home="../../../"

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-4 ...'
if [[ $FLUX_JOB_CC -eq $FLUX_JOB_CC ]]; then
    python -u  $home/main.py \
    --seed $FLUX_JOB_CC \
    --n_batch 128 \
    --n_layers 2 \
    --noregularize \
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
    --aligner $home/TRANSLATE/alignments/${align}.align.o.json \
    --copy \
    --TRANSLATE > eval.$FLUX_JOB_CC.out 2> eval.$FLUX_JOB_CC.err
fi
