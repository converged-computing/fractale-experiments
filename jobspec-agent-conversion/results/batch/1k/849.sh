#!/bin/bash
#
#FLUX: --job-name=DLC_extract_test
#FLUX: --output=output/R-DLC_extract_test.%J.txt
#FLUX: --error=output/ERR-DLC_extract_test.%J.txt
#
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#
#
module load EasyBuild/2022a

module load devel/python/Anaconda3-2022.05
conda activate DLC_dev
module load CUDA/11.7.0 TensorFlow/2.11.0-foss-2022a-CUDA-11.7.0

cd /gpfs/projects/acad/behavior/softs/DLC_scripts

python DLC_add_videos.py $1
