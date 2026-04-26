#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: --requires=K80
#FLUX: --time-limit=2d

module purge

module load CUDA
module load MATLAB/2019a

# The 'srun' command has been replaced with 'flux run'.
flux run matlab -nodisplay -nosplash < train_dqn.m
