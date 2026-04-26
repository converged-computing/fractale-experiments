#!/bin/bash

#FLUX: -t 5h
#FLUX: --mem=16G
#FLUX: --chdir=/home/jrick6/repos/data
#FLUX: --job-name=gen_image_var
#FLUX: --output=/home/jrick6/repos/data/logs/imagenette/set3/shard1/%x.%A.%a.out
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

# NOTE: The Slurm job array syntax with step and concurrency limit is not supported.
# You must submit this job with 'flux submit --cc=592-1183 ...'
# NOTE: The %x, %A, and %a format specifiers are not supported in Flux; files will be overwritten.

hostname

nvidia-smi

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. 
/home/jrick6/.conda/envs/simclr/bin/python generate_image_variations.py \
    -tfp "/home/jrick6/tensorflow_datasets/imagenette_id/full-size-v2/1.0.0/imagenette-train.tfrecord-00001-of-00016" \
    -o "/home/jrick6/tensorflow_datasets/imagenette_id_variations3/full-size-v2/1.0.0/dir_imagenette-train.tfrecord-00001-of-00016/imagenette-train.tfrecord-00001-of-00016" \
    --input_id ${FLUX_JOB_CC}
