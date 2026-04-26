#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --gpus-per-node=1
#FLUX: --output=logs/{id}.out
#FLUX: --error=logs/{id}.err
python train_metric_learning.py \
    --loss "triplet"  \
    --miner "TripletMargin" \
	--output_path "outputs_metric_learning/" \
    --dataset "aic19" \
    --dataset_path "./metric_learning_dataset/" \
	--model resnet_18 \
    --embedding_size 256 \
	--batch_size 64 \
    --epochs 20
