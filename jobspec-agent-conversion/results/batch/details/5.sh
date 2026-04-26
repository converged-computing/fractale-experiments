#!/bin/bash
#FLUX: --time-limit=2d
# The -p gpu (partition) directive is ignored. Note that this implies a GPU may be needed,
# but no GPU was explicitly requested.
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12

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
# The srun command is not needed for a single-process job in Flux.
python train.py ../../config/resnet98_78.ini
