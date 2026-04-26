#!/bin/sh

#
# time consumption HH:MM:SS
#FLUX: --time-limit=4d4h

#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
# #SBATCH --exclusive

# name for script
#FLUX: --job-name=snl_sbc

# controll job outputs
#FLUX: --output=lunarc_output/lunarc_output_snl_sbc_%j.out
#FLUX: --error=lunarc_output/lunarc_output_snl_sbc_%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'hodgkin_huxley'/run_script_sbc_snl.py 1 10 snl 76
