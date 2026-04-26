#!/bin/bash
#FLUX: --job-name=120_Iscr
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1


# NOTE: --mem-per-cpu and --hint=nomultithread are not supported.


module load MATLAB/2017b
# NOTE: This script is a job array. The SLURM variables have been replaced
# with Flux variables. You must submit this job with 'flux submit --cc=3500-3508 ...'
srun matlab -nodesktop -nosplash -r EEGlab_120_PreProcessed_v3 $FLUX_JOB_CC $FLUX_JOB_ID
