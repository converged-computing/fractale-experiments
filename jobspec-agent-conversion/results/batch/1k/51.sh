#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=24h
#FLUX: --gpus-per-node=1
#FLUX: --job-name=Network_trainer
#FLUX: --output=/home/mguamanc/job_%J.out
#FLUX: --error=/home/mguamanc/job_%J.err

# Executable
EXE=/bin/bash
WORKING_DIR=/data/datasets/mguamanc/learned_cost_map/cluster_scripts
EXE_SCRIPT=$WORKING_DIR/train_small.sh

USER=mguamanc

nvidia-docker run --rm --ipc=host -e CUDA_VISIBLE_DEVICES=`echo $CUDA_VISIBLE_DEVICES` -v /data/datasets:/data/datasets -v /home/$USER:/home/$USER -v /project:/project mguamanc/sara $EXE $EXE_SCRIPT
