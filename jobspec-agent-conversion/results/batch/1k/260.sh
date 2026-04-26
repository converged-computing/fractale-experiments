#!/bin/bash

#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=5h
#FLUX: --cc=1775-2366
#FLUX: --cwd=/home/jrick6/repos/data
#FLUX: --job-name=gen_image_var
#FLUX: --output=/home/jrick6/repos/data/logs/imagenette/set2/shard3/gen_image_var.out

hostname

nvidia-smi

/home/jrick6/.conda/envs/simclr/bin/python generate_image_variations.py \
    -tfp "/home/jrick6/tensorflow_datasets/imagenette_id/full-size-v2/1.0.0/imagenette-train.tfrecord-00003-of-00016" \
    -o "/home/jrick6/tensorflow_datasets/imagenette_id_variations2/full-size-v2/1.0.0/dir_imagenette-train.tfrecord-00003-of-00016/imagenette-train.tfrecord-00003-of-00016" \
    --input_id ${FLUX_JOB_CC}

