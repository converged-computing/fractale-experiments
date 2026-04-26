#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5h
#FLUX: --cc=8007-8807
#FLUX: --cwd=/home/jrick6/repos/data
#FLUX: --job-name=gen_image_var
#FLUX: --output=/home/jrick6/repos/data/logs/imagenet2012_subset_1pct/set0/shard10/gen_image_var.%J.%c.out

hostname

nvidia-smi

/home/jrick6/.conda/envs/simclr/bin/python generate_image_variations.py \
    -tfp "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id/1pct/5.0.0/imagenet2012_subset-train.tfrecord-00010-of-00016" \
    -o "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id_variations0/1pct/5.0.0/dir_imagenet2012_subset-train.tfrecord-00010-of-00016/imagenet2012_subset-train.tfrecord-00010-of-00016" \
    --input_id ${FLUX_JOB_CC}
