#!/bin/bash
#FLUX: --job-name=emgrep-cv
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=20
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5h
#FLUX: --cc=1-5
#FLUX: --output=logs/emgrep_cv-%J_%c.out
#FLUX: --error=logs/emgrep_cv-%J_%c.err

# Load modules
module load gcc/8.2.0 python_gpu/3.10.4 eth_proxy
pip install -q -r requirements.txt

# Run script
python main.py \
    --data /cluster/scratch/${USER}/nina_db/data/01_raw \
    --log_dir /cluster/scratch/${USER}/nina_db/logs \
    --debug \
    --wandb \
    --device cuda \
    --lr_cpc 2e-4 \
    --encoder_dim 512 \
    --ar_layers 5 \
    --ar_dim 512 \
    --positive_mode none \
    --split_mode subject \
    --val_idx ${FLUX_JOB_CC} \
    --test_idx $((${FLUX_JOB_CC} % 5 + 1)) 
