#!/bin/sh

# time consumption HH:MM:SS
#FLUX: --time-limit=2h

#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --exclusive

# name for script
#FLUX: --job-name=smcabc

 
# controll job outputs
#FLUX: --output=lunarc_output/lunarc_output_smcabc_%j.out
#FLUX: --error=lunarc_output/lunarc_output_smcabc_%j.err

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_smcabc.py 1 2 8 10
