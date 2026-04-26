#!/bin/bash
#FLUX: --job-name=tensordenoising
#FLUX: --time-limit=24h
#FLUX: --cc=1-500
#FLUX: --output=/vega/zmbbi/users/jss2219/TensorDenoising/yeti-output/tensordenoising.o%J.%c
#FLUX: --error=/vega/zmbbi/users/jss2219/TensorDenoising/yeti-error/tensordenoising.e%J.%c

# The following 'qsub' line from the original script has been removed.
# Submitting a new job from within a batch script is not a standard
# practice and may not work as expected in a Flux environment.
# The primary workload appears to be the matlab command below.
# Original line: qsub -q interactive -I -W group_list=yetizmbbi -l walltime=04:00:00,mem=4000mb

#Run Matlab
matlab -nosplash -nodisplay -nodesktop -r "tensorDenoiseCluster($FLUX_JOB_CC)" > /vega/zmbbi/users/jss2219/TensorDenoising/mat-outfile/matoutfile$FLUX_JOB_CC
