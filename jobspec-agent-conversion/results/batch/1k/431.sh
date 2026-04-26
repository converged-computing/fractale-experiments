#!/bin/bash
#FLUX: --job-name=Serial_Job
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=5

module load MATLAB/R2012b
# srun is not required for a single task job in Flux
matlab -nodesktop -nosplash -r myLu
