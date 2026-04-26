#!/bin/bash
#FLUX: --job-name=120_Iacc
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --cc=2500-2508

# The following SLURM directives could not be translated:
# --mem-per-cpu=4096
# --hint=nomultithread

module load MATLAB/2017b

# The SLURM array variables have been replaced with their Flux equivalents.
# This script uses the '--cc' flag to replicate the job array functionality.
flux run matlab -nodesktop -nosplash -r EEGlab_120_PreProcessed_v3 $FLUX_JOB_CC $FLUX_JOB_ID
