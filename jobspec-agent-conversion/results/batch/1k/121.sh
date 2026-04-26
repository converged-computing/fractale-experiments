#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
# The --mem 4096 directive has no direct flux analog and is omitted.
# The -p mhigh,mhigh (partition) directive is ignored as per instructions.
#FLUX: --gpus-per-task=1
#FLUX: --output=logs/%x_%u_%j.out 
#FLUX: --error=logs/%x_%u_%j.err 

python task_b.py \
    --loss "triplet"  \
    --miner "BatchHard" \
	--output_path "outputs_task_c/" \
    --dataset "mit_split" \
    --dataset_config_path "./configs/mit_split.yaml" \
    --dataset_path "/home/mcv/datasets/MIT_split/" \
	--model resnet_18 \
    --embedding_size 256 \
	--batch_size 64 \
    --epochs 20
