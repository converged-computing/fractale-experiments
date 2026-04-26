#!/bin/sh



# time consumption HH:MM:SS
#FLUX: --time-limit=2h

# #SBATCH -N 1
# #SBATCH --tasks-per-node=1
# #SBATCH --exclusive

# name for script
#FLUX: --job-name=snre_b

 
# controll job outputs
#FLUX: --output=lunarc_output/lunarc_output_snre_b_%j.out
#FLUX: --error=lunarc_output/lunarc_output_snre_b_%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.



# load modules

ml load GCC/8.3.0
ml load CUDA/10.1.243
ml load OpenMPI/3.1.4
ml load PyTorch/1.6.0-Python-3.7.4

# run program
python /home/samwiq/snpla/'seq-posterior-approx-w-nf-dev'/'two_moons'/run_script_snre_b.py 1 2 21 10 0
