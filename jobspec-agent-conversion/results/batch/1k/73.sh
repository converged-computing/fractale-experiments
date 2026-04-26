#!/bin/sh
#FLUX: --nodes=1 
#FLUX: --ntasks=1
#FLUX: --cores-per-task=48
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=200h

module load nvidia/cuda/9 #loading Modules
module load tools/tensorflow/1.8.0

time python Cnn_modified_alexnet.py # Command to run the desired code
