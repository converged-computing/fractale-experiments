#!/bin/sh


# Set up for run:

# need this since I use a LU project
#FLUX: -B lu2018-2-22

# use gpu nodes
#FLUX: -q gpu
#FLUX: --gpus-per-node=1

# NOTE: The Slurm directive '--mem-per-cpu=11000' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

# #FLUX: -N 1
# #FLUX: --ntasks=1


# time consumption HH:MM:SS
#FLUX: -t 100h

# name for script
#FLUX: --job-name=ar2_multi_ABC_pen

# controll job outputs
#FLUX: --output=lunarc_output/AR2/outputs_AR2_multiple_ABC_runs_pen_{flux:jobid}.out
#FLUX: --error=lunarc_output/AR2/errors_AR2_multiple_ABC_runs_pen_{flux:jobid}.err

# notification
# NOTE: The Slurm directives '--mail-user' and '--mail-type' were omitted as there are no direct Flux equivalents.

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
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/AR2/multiple_ABC_runs_pen.jl standard 250 1 1

# run using
# sbatch test_gpu.sh

