#!/bin/sh

#
# use gpu nodes
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1


# #SBATCH -N 1
# #SBATCH -n 1


# time consumption HH:MM:SS
#FLUX: --time-limit=4d4h

# name for script
#FLUX: --job-name=ar2_train_mlp

# controll job outputs
#FLUX: --output=lunarc_output/AR2/outputs_ar2_train_mlp_%j.out
#FLUX: --error=lunarc_output/AR2/errors_ar2_train_mlp_%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


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
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/AR2/train_mlp.jl mlp standard 50 4 1 0

# run using
# sbatch test_gpu.sh
