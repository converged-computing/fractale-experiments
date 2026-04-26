#!/bin/bash

#FLUX: --gpus-per-task=1
# The --exclude directive has no direct flux analog and is omitted.
#FLUX: --time-limit=5h
# The Slurm --array directive is replaced by the --cc flag at submission time.
# The step and concurrency limit (%30) have no direct Flux analog.
# This script should be submitted with: flux submit --cc=3203-4002 your_script_name.sh
# The --mem 16G directive has no direct flux analog and is omitted.
#FLUX: --cwd=/home/jrick6/repos/data
#FLUX: --job-name=gen_image_var
# The output format is different in Flux. %x and %A are not supported in the same way.
# Using %j for job ID.
#FLUX: --output=/home/jrick6/repos/data/logs/imagenet2012_subset_1pct/set0/shard4/gen_image_var.%j.out

hostname

nvidia-smi

# The SLURM_ARRAY_TASK_ID variable is replaced with FLUX_JOB_CC
/home/jrick6/.conda/envs/simclr/bin/python generate_image_variations.py \
    -tfp "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id/1pct/5.0.0/imagenet2012_subset-train.tfrecord-00004-of-00016" \
    -o "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id_variations0/1pct/5.0.0/dir_imagenet2012_subset-train.tfrecord-00004-of-00016/imagenet2012_subset-train.tfrecord-00004-of-00016" \
    --input_id ${FLUX_JOB_CC}
