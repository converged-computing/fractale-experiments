#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=14
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=1h

module purge
module use /appl/local/csc/modulefiles/
module load pytorch

COURSE_SCRATCH="/scratch/${FLUX_JOB_ACCOUNT}"

export DATADIR=$COURSE_SCRATCH/data
export TORCH_HOME=$COURSE_SCRATCH/torch-cache
export HF_HOME=$COURSE_SCRATCH/hf-cache
export MLFLOW_TRACKING_URI=$COURSE_SCRATCH/data/users/$USER/mlruns

set -xv
python3 $*

