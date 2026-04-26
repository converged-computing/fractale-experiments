#!/bin/bash
# The -q FIXME (queue) directive is ignored as per instructions and is a placeholder.
# The -l nodes=FIXME directive is a placeholder; a default of 1 node is assumed.
#FLUX: --nodes=1
# The -j oe directive means stdout and stderr are the same. This is achieved by setting
# --output and --error to the same file. The -o directive takes precedence.
#FLUX: --output=OpenMM.err
#FLUX: --error=OpenMM.err
# The -r n (not re-runnable) directive has no direct flux analog and is omitted.
#FLUX: --job-name=5Y2S_GPU_OpenMM

## If you get a segfalt error and you're a TINKER user
## add the .bashrc_blank file to $HOME on Cruntch and 
## uncomment this line.
#source ~/.bashrc_blank

## The specific GPU card to use
## Change "0" to the one you want
## NOTE: Flux manages GPU visibility automatically. This line is usually not needed.
# export CUDA_VISIBLE_DEVICES=0

## Go to the directory that the job was submitted from
# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

## Load OpenMM
## K80s use CUDA 8.0, V100s use CUDA 10.0
module load openmm/cuda-8.0
#module load openmm/cuda-10.0

## Run the Python Script and print Terminal output to file
python new_openmm_simulations.py
