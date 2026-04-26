#!/bin/bash

#FLUX: --job-name=hm-2020-07-21-Contopus_virens
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --output=/labs/Tingley/phenomismatch/Bird_Phenology/Data/Processed/arrival_IAR_hm_2020-07-21/Contopus_virens-iar-hm.out
#FLUX: --error=/labs/Tingley/phenomismatch/Bird_Phenology/Data/Processed/arrival_IAR_hm_2020-07-21/Contopus_virens-iar-hm.err

#echos name of node
echo `hostname`

module load gcc/6.4.0
module load singularity/3.0.2
singularity exec -B /labs/Tingley -B /UCHC /isg/shared/apps/R/3.5.2/R.sif Rscript /labs/Tingley/phenomismatch/Bird_Phenology/Scripts/4-arr-IAR-hm/4-arr-IAR-hm.R Contopus_virens 5000

# The sstat command has no direct equivalent in Flux.
# You can get job information with 'flux job info $FLUX_JOB_ID'
