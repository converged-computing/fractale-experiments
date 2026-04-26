#!/usr/bin/env bash

#FLUX: --time-limit=6h
#FLUX: --gpus-per-task=2
#FLUX: --ntasks=1
#FLUX: --cc=1-5
#FLUX: --output="<absolute-path-to-code>/slurmlogs/job.out"

echo "$FLUX_JOB_ID" > "$FLUX_JOB_ID"

eval "$(conda shell.bash hook)"

conda activate <path-to-conda-env>

echo "Hello World"

nvidia-smi

python ddp_train_nerf.py --config configs/angle/0.01.txt

echo Finished

