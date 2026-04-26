#!/bin/bash
#FLUX: --job-name=icarl_5
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --time-limit=12h

# The SLURM directive '--mem=24GB' could not be translated.

# the required parameter is just the prefix for storing the model
if [ $# -ne 1 ]; then
  exit
fi

# clean the module environment that we may have inherited from the calling session
ml purge

# load the relevant modules
ml PyTorch/0.4.0-gomkl-2018b-Python-2.7.15-CUDA-9.2.88
ml torchvision/0.2.1-gomkl-2018b-Python-2.7.15-CUDA-9.2.88 

echo 'Starting job'
# run the script
python main.py "$1"
