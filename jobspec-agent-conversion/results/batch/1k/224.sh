#!/bin/sh

#FLUX: --time-limit=5h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --job-name=snpla
#FLUX: --output=lunarc_output/lunarc_output_hp_snpla_%j.out
#FLUX: --error=lunarc_output/lunarc_output_hp_snpla_%j.err

# NOTE: The Slurm %j format for job ID in filenames is not supported in Flux directives.
# The output and error files will be named literally with '%j'.

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snpla.py 1 2 11 10 0 0.85
