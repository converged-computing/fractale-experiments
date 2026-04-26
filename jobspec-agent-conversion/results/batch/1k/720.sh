#!/bin/bash
#FLUX: --job-name=repn_learning   
#FLUX: --time-limit=1h10m
#FLUX: --output=repn_learning%A%a.out
#FLUX: --error=repn_learning%A%a.err


# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-575 ...'
python learner_xrel.py --search --save_losses --cfg ./cfg_temp/$FLUX_JOB_CC.json
