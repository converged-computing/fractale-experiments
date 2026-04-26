#!/bin/bash
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=5h
#FLUX: --cc=3203-4002
#FLUX: --cwd=/home/jrick6/repos/data
#FLUX: --job-name=gen_image_var
#FLUX: --output=/home/jrick6/repos/data/logs/imagenet2012_subset_1pct/set0/shard4/{job_name}.{id}.out

# The --mem 16G parameter from slurm has no direct equivalent in flux-submit.
# Each job in the array may be scheduled on a node without enough memory.
# The --exclude parameter from slurm has no direct equivalent in flux-submit.
# The array job throttling feature (%30) is not supported and has been omitted.
# The output file will be shared by all tasks in the array, which will corrupt the log file.

hostname

nvidia-smi

/home/jrick6/.conda/envs/simclr/bin/python generate_image_variations.py \
    -tfp "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id/1pct/5.0.0/imagenet2012_subset-train.tfrecord-00004-of-00016" \
    -o "/home/jrick6/tensorflow_datasets/imagenet2012_subset_id_variations0/1pct/5.0.0/dir_imagenet2012_subset-train.tfrecord-00004-of-00016/imagenet2012_subset-train.tfrecord-00004-of-00016" \
    --input_id ${FLUX_JOB_CC}
