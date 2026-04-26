#!/bin/bash

# Params for sbatch
#FLUX: --job-name=ssp_home
#FLUX: --output=%j_ssp.out
#FLUX: --error=%j_ssp.err
#FLUX: --time-limit=6h
#FLUX: --cc=1-299

# The --output and --error directives do not support Slurm-style job ID substitution (%j).
# All jobs in the collection will write to the same files.

# Set environment 
module add jaspy
cd /home/users/tommatthews/Homeostasis/
source /home/users/tommatthews/Homeostasis/xheat/bin/activate

# Launch
python compute_ssp.py ${FLUX_JOB_CC}







