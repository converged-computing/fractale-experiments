#!/bin/bash 
#FLUX: --cc=1-N # IMPORTANT: The array range was not specified in the original script. Please replace 'N' with the desired number of tasks.

# Slurm's dynamic output filename (-o %A_%a) is not supported in Flux directives.
# We redirect output in the script body using Flux environment variables instead.
# Note: Slurm's %A (master job ID) is replaced by Flux's unique FLUX_JOB_ID for each job in the set.

singularity exec -B /mnt/f:/data/ \
/mnt/f/Docker/BrinkmanLabSingularity/brinkman_lab_singularity_190418.im Rscript \
/data/Brinkman\ group/COVID/data/code/data_check.R ${FLUX_JOB_CC} > COVID_FILE_CHECK_${FLUX_JOB_ID}_${FLUX_JOB_CC}.out
