#!/bin/bash

#FLUX: --job-name=t-mf-l
#FLUX: --output=log_train_mf_lhc_{flux:cc}.log
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: -t 7d
# #FLUX: --gpus-per-node=1

# NOTE: The Slurm directive '--mem=32GB' was omitted as there is no direct Flux equivalent.
# This could lead to the job failing if scheduled on a node with insufficient memory.

# module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

# Note: This script is designed as a job array. It should be submitted with an option like --cc=RANGE
# For example: flux submit --cc=0-9 this_script.sh
python -u train.py -c configs/train_mf_lhc_june.config -i ${FLUX_JOB_CC}
