#!/bin/sh


#FLUX: -B lu2020-2-7
#FLUX: -q lu

# time consumption HH:MM:SS
#FLUX: -t 2h

# #FLUX: -N 1
# #FLUX: --tasks-per-node=1
# #FLUX: --exclusive

# name for script
#FLUX: --job-name=snre_b

 
# controll job outputs
#FLUX: --output=lunarc_output/lunarc_output_snre_b_{flux:jobid}.out
#FLUX: --error=lunarc_output/lunarc_output_snre_b_{flux:jobid}.err

# notification
# NOTE: The Slurm directives '--mail-user' and '--mail-type' were omitted as there are no direct Flux equivalents.

# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snre_b.py 1 2 19 10 0

