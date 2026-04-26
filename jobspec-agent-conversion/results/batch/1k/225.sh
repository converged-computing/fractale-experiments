#!/bin/sh


# The -A (account) and -p (partition) directives are ignored.

# time consumption HH:MM:SS
#FLUX: --time-limit=2h

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --exclusive

# name for script
#FLUX: --job-name=snre_b


# controll job outputs
#FLUX: --output=lunarc_output/lunarc_output_snre_hp_%j.out
#FLUX: --error=lunarc_output/lunarc_output_snre_hp_%j.err

# The --mail-user and --mail-type directives are ignored.

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snre_b.py 1 2 11 10 8
