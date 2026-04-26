#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=30m
#FLUX: --job-name=tf_test
#FLUX: --output=tf_test.out
#FLUX: --error=tf_test.err
#FLUX: --gpus-per-task=4

# pull singularity image
# this is a one-time setup. Once downloaded, you don't need to pull it again
# The srun command is not necessary in Flux for this operation
singularity pull --disable-cache docker://tensorflow/tensorflow:latest-gpu

# --- run code tf_test_multi_gpu.py ---
singularity exec --nv tensorflow_latest-gpu.sif python tf_test_multi_gpu.py
