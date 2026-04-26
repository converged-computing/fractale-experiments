#!/usr/bin/env bash

#FLUX: --job-name=donut-train
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --cores-per-task=8

nvidia-smi

cd ~/donut

module load cuda/12.2
module load python/3.9.18

python3.9 train.py \
	--config config/train_es.yaml \
	--pretrained_model_name_or_path "naver-clova-ix/donut-base" \
	--dataset_name_or_paths '["synthdog/outputs/SynthDoG_es"]' \
	--exp_version "synthdog"

module unload python/3.9.18
module unload cuda/12.2
