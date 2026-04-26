#!/bin/bash

# SLURM Resource Parameters

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time=1d
#FLUX: --gpus-per-task=1
#FLUX: --job-name=Network_trainer
#FLUX: --output=/home/mguamanc/job_%j.out
#FLUX: --error=/home/mguamanc/job_%j.err


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.
# NOTE: The specific node request (-w bender) is not supported.

# Executable
EXE=/bin/bash
WORKING_DIR=/data/datasets/mguamanc/learned_cost_map/cluster_scripts
EXE_SCRIPT=$WORKING_DIR/train_med.sh

USER=mguamanc

nvidia-docker run --rm --ipc=host -e CUDA_VISIBLE_DEVICES=`echo $CUDA_VISIBLE_DEVICES` -v /data/datasets:/data/datasets -v /home/$USER:/home/$USER -v /project:/project mguamanc/sara $EXE $EXE_SCRIPT
