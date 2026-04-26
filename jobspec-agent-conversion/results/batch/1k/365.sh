#!/bin/bash

#FLUX: --time-limit=400h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: --job-name=$log_name
#FLUX: --error=/home/laine/PROJECTS_IO/CARODEEPFLOW/log/$log_name.err
#FLUX: --output=/home/laine/PROJECTS_IO/CARODEEPFLOW/log/$log_name.out
#FLUX: --cwd=/home/laine/REPOSITORIES/CCA_DL_TOOLS/caroDeepMotion

source ~/anaconda3/etc/profile.d/conda.sh
conda activate pytorch

# run script
WD=/home/laine/REPOSITORIES/CCA_DL_TOOLS/caroDeepMotion
PYTHONPATH=$WD python package_cores/run_training_flow.py -param $param
