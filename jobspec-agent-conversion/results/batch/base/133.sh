#!/bin/bash
#FLUX: --job-name=120_Iacc
#FLUX: -B uoa00424
#FLUX: -t 10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: -q bigmem
#FLUX: --cc=2500-2508

# NOTE: The Slurm directive '--mem-per-cpu=4096' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The Slurm directive '--hint=nomultithread' was omitted as there is no direct Flux equivalent.
# This may impact performance if the application is sensitive to hyperthreading.
# NOTE: The Slurm directives for email notification ('--mail-type', '--mail-user') were omitted as there are no direct Flux equivalents.

module load MATLAB/2017b

# The srun command is not needed in Flux, and Slurm environment variables have been replaced with Flux equivalents.
matlab -nodesktop -nosplash -r "EEGlab_120_PreProcessed_v3 $FLUX_JOB_CC $FLUX_JOB_ID"

