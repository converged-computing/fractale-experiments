#!/bin/bash
#FLUX: --cores-per-task=32
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=1d
#FLUX: --job-name=uji
#FLUX: --output=/home/qfournie/logs/%x-%j



# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

# LOAD MODULES
module load python/3.5
module load cuda/9.0
module load cudnn/7.0

# LOAD VIRTUAL ENVIRONMENT
source ~/keras-env/bin/activate

# TASK
cd /home/qfournie/dimensionality_reduction

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1,3,5,...'
python3 main.py -d uji -t dimension -c knn --start_dim $FLUX_JOB_CC --n_dim 1
