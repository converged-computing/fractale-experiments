#!/bin/sh

#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=100h
#FLUX: --job-name=gandk_multi_ABC_deepsets4
#FLUX: --output=lunarc_output/gandk/outputs_gandk_multiple_deepsets.out
#FLUX: --error=lunarc_output/gandk/errors_gandk_multiple_deepsets.err

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
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/'g and k dist'/multiple_ABC_runs_deepsets.jl standard 500 4 0

