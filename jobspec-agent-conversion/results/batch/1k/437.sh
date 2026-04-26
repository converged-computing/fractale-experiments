#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=48h
#FLUX: --output=Errors/job.%J.out
#FLUX: --error=Errors/job.%J.err


module purge 

source /share/apps/NYUAD/miniconda/3-4.11.0/bin/activate

conda activate tf-env2

export TF_CPP_MIN_LOG_LEVEL="2"
#echo $LD_LIBRARY_PATH

#Execute the code
#python test.py

python main.py "../DatabaseV2/TrainSet" "../DatabaseV2/TestSet"
