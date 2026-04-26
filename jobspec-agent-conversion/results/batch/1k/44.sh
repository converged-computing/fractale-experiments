#!/bin/bash
#FLUX: --job-name=3Adj-EGNNA
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=slurm_output/color_rgb_lstsrtmssm_egnna_top10_excel%A_%a.out


# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.

source activate py_env2
module load cuda/10.0

export PYTHONPATH="${PYTHONPATH}:/homes/svincenzi/.conda/envs/py_env2/bin/python"

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-1 ...'
python -u main.py --id_optim=${FLUX_JOB_CC}
