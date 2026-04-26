#!/bin/bash
#FLUX: --time-limit=2d


#Prepare python environment
export PYTHONPATH=$HOME/pythonpackages/lib/python:$PYTHONPATH
module load python/2.7.9
module load cuda
module load cudnn

#Go to project folder
cd $HOME/luna16/src/deep


#Go!!!
echo "starting python"
export THEANO_FLAGS='mode=FAST_RUN,device=gpu,floatX=float32,lib.cnmem=1' 
# srun is not required for a single task job in Flux
python -u train.py ../../config/titan_x_default.ini ../../config/split89.ini
