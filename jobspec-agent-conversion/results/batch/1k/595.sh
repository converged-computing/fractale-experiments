#!/bin/bash
#FLUX: --gpus-per-task=4
#FLUX: --ntasks=1
#FLUX: --time-limit=20h
#FLUX: --output=real_multiple_gpu.out

# Set up environment
module load GCC Singularity git

# Clone tensorflow repo to run a tutorial
# git clone https://github.com/tensorflow/models.git
singularity exec --nv docker://tensorflow/tensorflow:latest-gpu \
    python tf_cnn_benchmarks.py --data_format=NCHW --batch_size=256 \
--model=resnet56 --optimizer=momentum --variable_update=replicated \
--nodistortions --num_gpus=4 \
--num_epochs=90 --weight_decay=1e-4 --data_dir=cifar10_data --use_fp16 \
--train_dir=cifar10_train --data_name=cifar10

