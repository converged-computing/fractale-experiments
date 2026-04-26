#!/bin/sh

#FLUX: --bank=lu2020-2-7
#FLUX: --queue=lu
#FLUX: --time-limit=2h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --exclusive
#FLUX: --job-name=smcabc
#FLUX: --output=lunarc_output/lunarc_output_smcabc_{id}.out
#FLUX: --error=lunarc_output/lunarc_output_smcabc_{id}.err

# The SLURM --mail-user and --mail-type directives have no direct Flux analog.

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_smcabc.py 1 2 8 10
