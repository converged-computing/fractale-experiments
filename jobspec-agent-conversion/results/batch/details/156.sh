#!/bin/bash

#FLUX: --job-name=t-emf-l
#FLUX: --output=log_train_emf_lhc.log
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=7d

# The SLURM directive '--mem=32GB' could not be translated.
# The dynamic log filename using the array task ID is not supported.

# module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

# The SLURM_ARRAY_TASK_ID variable has been replaced with its Flux equivalent.
# This script should be submitted with the 'flux submit --cc=...' flag for this variable to be populated.
python -u train.py -c configs/train_mf_lhc_june.config --algorithm emf -i ${FLUX_JOB_CC}
