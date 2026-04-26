#!/bin/bash
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=50m
#FLUX: --output=sbatch_out/automate_ablations.%A.%a.out
#FLUX: --error=sbatch_err/automate_ablations.%A.%a.err
#FLUX: --job-name=automate_ablations

module load anaconda/3
module load cuda/11.7
module load libffi

source /home/mila/s/sonia.joseph/ViT-Planetarium/env/bin/activate

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-9 ...'
python automate_ablations.py --layer_num $FLUX_JOB_CC --layer_type "fc2"
