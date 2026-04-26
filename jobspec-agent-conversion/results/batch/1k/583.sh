#!/bin/bash

#FLUX: --time-limit=2h
#FLUX: --job-name=ASR-DDP-check
#FLUX: --nodes=1
#FLUX: --gpus-per-node=2
#FLUX: --requires=v100-32g
#FLUX: --cc=0-1:1

# The --cpus-per-gpu=2 directive has no direct analog in the provided flux submit options.
# The --account directive was ignored as per instructions.

source activate pt
nvidia-smi
echo $PATH
# cd $SLURM_SUBMIT_DIR # Flux starts in the submission directory by default
python -m torch.distributed.launch --nproc_per_node=2 main.py \
        --nnodes 2 \
        --gpus 2 \
        --node_rank ${FLUX_JOB_CC} \
        --nepochs 60 \
        --epochs-done 0 \
        --train-path '/users/PAS1939/vishal/datasets/librispeech/train_full_960.csv' \
        --logging-file 'logs/conf_16L128H4A_asr.log' \
        --save-path '/users/PAS1939/vishal/saved_models/debug_ddp.pth.tar' \
        --ckpt-path '' \
        --enc-type 'conf' \
        --batch-size 512 \
        --bsz-small 8 \
        --in-dim 960 \
        --n-layer 16 \
        --hid-tr 128 \
        --nhead 4 \
        --hid-pr 1024 \
        --lr 0.001 \
        --clip 5.0 \
        --dropout 0.25
