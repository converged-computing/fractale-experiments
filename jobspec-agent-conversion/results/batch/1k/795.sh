#!/bin/bash
#FLUX: --time-limit=4h

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=2
#FLUX: --cores-per-task=8

#FLUX: --gpus-per-node=1

#FLUX: --error=logs/train_flow_%j.out
#FLUX: --output=logs/train_flow_%j.out


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

ml torchsparse

cd $HOME

python -u motion_supervision/train.py
