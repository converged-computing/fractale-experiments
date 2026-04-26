#!/bin/sh

#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=100h
#FLUX: --job-name=univaralphastable_train_deepsets
#FLUX: --output=lunarc_output/univaralphastable/outputs_univaralphastable_train_deepsets.out
#FLUX: --error=lunarc_output/univaralphastable/errors_univaralphastable_train_deepsets.err

# we need to load the cuda stuff here!

# load modules

ml load GCC/6.4.0-2.28
ml load CUDA/9.1.85
ml load OpenMPI/2.1.2
ml load cuDNN/7.0.5.15
ml load julia/1.0.0

nvidia-smi

# set correct path
pwd
cd ..
pwd

# run program
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/'alpha stable dist'/train_deepsets.jl standard 100 1 1

