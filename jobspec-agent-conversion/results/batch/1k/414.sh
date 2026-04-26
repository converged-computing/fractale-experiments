#!/usr/bin/env bash

#FLUX: --time-limit=20h
#FLUX: --job-name=knn_isd_3
#FLUX: --output=logs/knn_isd_3.txt
#FLUX: --error=logs/knn_isd_3.txt
#FLUX: --gpus-per-node=4
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=16

set -x
set -e

for exp_dir in output/isd_3_*_resnet18
do
    python eval_knn.py \
        -j 16 \
        -b 256 \
        --arch resnet18 \
        --weights $exp_dir/ckpt_epoch_200.pth \
        --save $exp_dir \
        /nfs/ada/hpirsiav/datasets/imagenet
done
