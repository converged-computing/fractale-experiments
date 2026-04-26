#!/bin/bash
#FLUX: --job-name=itrust-emotions
#FLUX: --cc=0-14
#FLUX: --time-limit=5d

# Slurm's dynamic output/error filenames (%A-%a) are not supported in Flux directives.
# We create the directories and redirect output in the script body using Flux variables.
mkdir -p outputs
mkdir -p errors

source .emotions_env/bin/activate

# Note: Slurm's %A (master job ID) is replaced by Flux's unique FLUX_JOB_ID for each job in the set.
python metric_calculator_emotions.py ${FLUX_JOB_CC} > outputs/emotions-${FLUX_JOB_ID}-${FLUX_JOB_CC}.out 2> errors/emotions-${FLUX_JOB_ID}-${FLUX_JOB_CC}.err
