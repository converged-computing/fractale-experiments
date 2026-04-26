#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --queue=mhigh,mhigh
#FLUX: --gpus-per-task=1
#FLUX: --output=logs/{job-name}_$USER_{id}.out
#FLUX: --error=logs/{job-name}_$USER_{id}.err

# The SLURM --mem directive has no direct Flux analog in the provided documentation.

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
