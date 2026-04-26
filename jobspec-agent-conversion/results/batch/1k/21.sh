#!/bin/bash
# Tensorflow with GPU support example submit script for Flux.
#
# Replace <ACCOUNT> with your account name before submitting.
#
#FLUX: --job-name=tensorflow
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=11h30m
#FLUX: --gpus-per-task=1

module load singularity

singularity exec --nv /moto/opt/singularity/tensorflow-1.13-gpu-py3-moto.simg python train_STG_circuit.py med $1 $2 $3 $4 $5 
