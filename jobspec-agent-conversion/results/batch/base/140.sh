#!/bin/bash

#FLUX: --job-name=nas
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=23h59m59s
#FLUX: --queue=gpu
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=8
#FLUX: --output=nas5.out

source ~/.bashrc
conda deactivate
conda activate new

## Load the python interpreter
module load python

## Execute the python script
# The srun command is not needed for a single-task job in Flux.
python nas.py
