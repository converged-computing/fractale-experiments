#!/bin/bash

#FLUX: --job-name=ISIC2020_1_ResNet152V2_384h_384w

#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --gpus-per-task=1

#FLUX: --time-limit=1d

#FLUX: --output=/home/sanghyuk.kim001/MELANOMA/melanoma-detection-CNN/SLURMS/LOGS/ResNet152V2/%x_%A_%a.out
#FLUX: --error=/home/sanghyuk.kim001/MELANOMA/melanoma-detection-CNN/SLURMS/LOGS/ResNet152V2/%x_%A_%a.err



eval "$(conda shell.bash hook)"
conda activate clean_chimera_env

echo `date`


# For debugging purposes.
python --version
nvcc -V

# Print this sub-job's task ID
# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with a --cc flag.
echo "My FLUX_JOB_CC: " $FLUX_JOB_CC

cd /home/sanghyuk.kim001/MELANOMA/melanoma-detection-CNN/

python train.py --DB ISIC2020 --IMG_SIZE 384 384 --CLASSIFIER ResNet152V2 --JOB_INDEX $FLUX_JOB_CC

echo "Job ended!"

# end
exit 0;
