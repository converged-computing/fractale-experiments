#!/bin/bash
# FILENAME: job.sh
#FLUX: --output=myjob.out
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=4h
#FLUX: --job-name=cifar-resnet

module load anaconda
module load use.own
conda env remove --name d22env
conda create --name d22env python=3.11 jupyter pytorch torchvision matplotlib pandas -y
source activate d22env
conda info --envs
echo -e "module loaded"
