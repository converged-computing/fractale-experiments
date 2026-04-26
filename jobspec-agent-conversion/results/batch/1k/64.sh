#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --exclusive
#FLUX: --time-limit=3d
#FLUX: --output=%a.ssp1_out
#FLUX: --error=%a.ssp1_err

# NOTE: The %a format specifier is not supported in Flux; files will be overwritten.

# THIS IS IMPORTANT OR THE MODULES WILL NOT IMPORT
. /etc/profile.d/modules.sh
module load python/3.6.3
module load cuda/8.0
module load cudnn/6.0

pip3 install --user virtualenv
#conda install --user virtualenv
virtualenv -p python3 venv
source venv/bin/activate
pip3 install -r baseline_req.txt
KERAS_BACKEND=tensorflow

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-7 ...'
python3 ecr_ssp.py $FLUX_JOB_CC
