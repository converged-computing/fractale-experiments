#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --job-name=nsbh


module purge
source /share/apps/anaconda/3-2019.03/etc/profile.d/conda.sh
conda activate condagw3
module load rocks-openmpi_ib

# NOTE: This script is a job array. The SLURM variables have been replaced
# with a hardcoded count and the FLUX_JOB_CC variable. You must submit this job with 'flux submit --cc=1-24 ...'
TASK_COUNT=24
TASK_ID=$FLUX_JOB_CC

time python sim_nsbh_analysis.py $TASK_COUNT $TASK_ID
