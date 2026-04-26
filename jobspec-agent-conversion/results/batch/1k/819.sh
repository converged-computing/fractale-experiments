#!/bin/sh
#FLUX: -N 3
#FLUX: --gpus-per-node=2
#FLUX: --cores=18

# The PBS directive '-j oe' to join output/error files has no direct Flux translation and was omitted.
# Project, queue, and mail directives were ignored as per instructions.

## SPECIFY JOB NOW

CURTIME=$(date +%Y%m%d%H%M%S)
module load apps/pythonpackages/3.6.0/pytorch/0.4.1/gpu
## Change to dir from where script was launched






