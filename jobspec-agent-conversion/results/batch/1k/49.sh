#!/bin/bash

#FLUX: --nodes=1
#FLUX: --time-limit=48h
#FLUX: --job-name=t-lightning
#FLUX: --gpus-per-node=8
#FLUX: --requires=v100-32
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=5
#FLUX: --output=job-%A-%a.out
#FLUX: --error=job-%A-%a.err

# The --output and --error directives do not support Slurm-style substitutions (%A, %a).
# This script assumes it will be run as a concurrent job set, e.g., 'flux submit --cc=1-N'.

'bash' train.job ${FLUX_JOB_CC}
