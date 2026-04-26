#!/bin/bash
#FLUX: --time-limit=2d
#FLUX: --queue=gpu
#FLUX: --cores-per-task=12
#FLUX: --ntasks=1

#Prepare python environment
export PYTHONPATH=$HOME/pythonpackages/lib/python:$PYTHONPATH
export PYTHONPATH=$HOME/pythonpackages/lib/python2.7/site-packages:$PYTHONPATH
module load python/2.7.9
module load cuda
module load cudnn

#Go to project folder
cd $HOME/luna16/src/deep

#Go!!!

echo "starting python"
export THEANO_FLAGS='mode=FAST_RUN,device=gpu,floatX=float32,lib.cnmem=1'

# The srun command is not needed for a single-task job in Flux.
python -u train.py ../../config/resnet98_78.ini
