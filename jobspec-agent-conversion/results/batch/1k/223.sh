#!/bin/sh
#FLUX: --time-limit=4h
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --exclusive
#FLUX: --job-name=snl
#FLUX: --output=lunarc_output/snl.out
#FLUX: --error=lunarc_output/snl.err

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snl.py 1 2 11 10 1
