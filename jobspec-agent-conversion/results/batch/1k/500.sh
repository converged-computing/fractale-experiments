#! /bin/bash
#
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#


#Load modules
module reset
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW_INFER_T4: Normal beginning of execution."
python beginner.py
echo "TENSORFLOW_INFER_T4: Normal end of execution."
