#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=3h
#FLUX: --cc=1-11
 
cd $HOME
module load anaconda3/personal
source activate fyp
cd big/container/psilocybrain
 
# The PBS array index variable has been replaced with the Flux concurrent job variable.
python train_vgae.py $FLUX_JOB_CC
