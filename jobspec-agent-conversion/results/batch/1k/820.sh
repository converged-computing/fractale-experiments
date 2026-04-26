#!/bin/bash
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --cores=2

# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.

#Name of job
#Dep name , project name
## SPECIFY JOB NOW

JOBNAME=HPRSR
CURTIME=$(date +%Y%m%d%H%M%S)
# PBS's $PBS_O_WORKDIR is equivalent to Flux's $FLUX_SUBMIT_DIR
cd $FLUX_SUBMIT_DIR 
##module load apps/pythonpackages/3.6.0/pytorch/0.4.1/gpu
##module load apps/anaconda3/4.6.9
## Change to dir from where script was launched
##conda activate tr3
