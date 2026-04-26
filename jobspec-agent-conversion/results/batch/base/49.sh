#!/bin/sh


# Set up for run:

# need this since I use a LU project
#FLUX: --bank=lu2018-2-22

# use gpu nodes
#FLUX: --queue=gpu
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1

# The --mem-per-cpu=3100 parameter from slurm has no direct equivalent in flux-submit.

# time consumption HH:MM:SS
#FLUX: --time-limit=100h

# name for script
#FLUX: --job-name=ar2_multi_ABC_mlp

# controll job outputs
#FLUX: --output=lunarc_output/AR2/outputs_AR2_multiple_ABC_runs_mlp_{id}.out
#FLUX: --error=lunarc_output/AR2/errors_AR2_multiple_ABC_runs_mlp_{id}.err

# notification
# The --mail-user and --mail-type parameters from slurm have no direct equivalent in flux-submit.


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
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/AR2/multiple_ABC_runs_mlp.jl mlp standard 250 1 1 0

# run using
# sbatch test_gpu.sh

