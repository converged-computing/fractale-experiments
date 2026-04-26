#!/bin/bash
#FLUX: --gpus-per-node=4
#FLUX: --ntasks=1
#FLUX: --time-limit=20h
#FLUX: --output=inception_multiple_gpu.out


# Set up environment
module load GCC Singularity git

# Clone tensorflow repo to run a tutorial
# git clone https://github.com/tensorflow/models.git
singularity exec --nv docker://tensorflow/tensorflow:latest-gpu \
    python tf_cnn_benchmarks.py --num_gpus=4 --batch_size=32 --model=inception3 --variable_update=parameter_server
