#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-node=1
#FLUX: --requires=K80
#FLUX: --time-limit=48h

# The --mem-per-cpu=7764 parameter (approx. 31GB total) has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.


module purge

module load CUDA
module load MATLAB/2019a

# The 'srun' command is not needed for a single-task job in Flux.
matlab -nodisplay -nosplash < train_dqn.m
