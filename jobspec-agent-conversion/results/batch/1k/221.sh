#!/bin/sh

#FLUX: --time-limit=1h
#FLUX: --job-name=snpe_c
#FLUX: --output=lunarc_output/snpe_c.out
#FLUX: --error=lunarc_output/snpe_c.err

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snpe_c.py 1 2 18 10 0
