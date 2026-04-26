#!/bin/bash
#FLUX: -q FIXME
#FLUX: --nodes=FIXME
#FLUX: --output=OpenMM.err
#FLUX: --error=OpenMM.err
#FLUX: --job-name=5Y2S_GPU_OpenMM

# NOTE: The PBS directive '-r n' (job not rerunnable) was omitted as there is no direct Flux equivalent.
# NOTE: The PBS directive '-j oe' was handled by setting the output and error paths to be the same.

## If you get a segfalt error and you're a TINKER user
## add the .bashrc_blank file to $HOME on Cruntch and 
## uncomment this line.
#source ~/.bashrc_blank

## The specific GPU card to use
## Change "0" to the one you want
## This may be redundant if a single GPU is requested from Flux.
export CUDA_VISIBLE_DEVICES=0

## Go to the directory that the job was submitted from
cd $FLUX_SUBMIT_CWD

## Load OpenMM
## K80s use CUDA 8.0, V100s use CUDA 10.0
module load openmm/cuda-8.0
#module load openmm/cuda-10.0

## Run the Python Script and print Terminal output to file
python new_openmm_simulations.py

