#!/bin/bash

#FLUX: --job-name="dnf_gan2d"
#FLUX: --time-limit=1d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1





cd /storage/homefs/ch19g182/Python/Denoising-Normalizing-Flow-master/experiments

nvcc --version
nvidia-smi

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-10 ...'
python train.py -c configs/train_dnf_gan2d.config -i ${FLUX_JOB_CC}
