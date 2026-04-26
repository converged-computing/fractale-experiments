#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=14
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=1h

module purge
module use /appl/local/csc/modulefiles/
module load pytorch

# NOTE: The SLURM_JOB_ACCOUNT variable was replaced with a placeholder.
# You must edit this line to provide your correct account/project name.
COURSE_SCRATCH="/scratch/<YOUR_ACCOUNT_NAME>"

export DATADIR=$COURSE_SCRATCH/data
export TORCH_HOME=$COURSE_SCRATCH/torch-cache
export HF_HOME=$COURSE_SCRATCH/hf-cache
export MLFLOW_TRACKING_URI=$COURSE_SCRATCH/data/users/$USER/mlruns

set -xv
torchrun --standalone --nnodes=1 --nproc_per_node=2 $*
