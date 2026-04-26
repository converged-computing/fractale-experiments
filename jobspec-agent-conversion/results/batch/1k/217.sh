#!/bin/sh

# The -A lu2018-2-22 (account) and -p gpu (partition) directives are ignored.
#FLUX: --gpus-per-task=1
# The --mem-per-cpu=11000 directive has no direct flux analog and is omitted.
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=100h
#FLUX: --job-name=ar2_multi_ABC_pen
#FLUX: --output=lunarc_output/AR2/outputs_AR2_multiple_ABC_runs_pen_%j.out
#FLUX: --error=lunarc_output/AR2/errors_AR2_multiple_ABC_runs_pen_%j.err
# The --mail-user and --mail-type directives are ignored.

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
