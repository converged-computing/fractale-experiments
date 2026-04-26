#!/bin/bash
#FLUX: --job-name=known
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=20h

# example run commands

module load tensorflow/1.14.0

python3 train_stage_2.py

# The seff command has no direct equivalent in Flux.
# You can get job information with 'flux job info $FLUX_JOB_ID'
