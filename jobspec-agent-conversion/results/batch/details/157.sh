#!/bin/bash

#FLUX: --job-name=t-mf-l
# The Slurm output pattern %a is not directly supported; using %j for unique job IDs.
#FLUX: --output=log_train_mf_lhc_%j.log
#FLUX: --nodes=1
#FLUX: --cores-per-task=4
#FLUX: --ntasks=1
# The --mem=32GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=7d
# The --gres=gpu:1 directive was commented out and is ignored.

# module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

# Note: This script is intended to be run as a job array, e.g., `flux submit --cc=1-N script.sh`
# The Slurm array task ID is replaced with the Flux job collection variable.
python -u train.py -c configs/train_mf_lhc_june.config -i ${FLUX_JOB_CC}
