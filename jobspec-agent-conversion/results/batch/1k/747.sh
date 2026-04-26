#!/bin/bash

#FLUX: --job-name=PYTHON
#FLUX: --output=outputs/results.o%j
#FLUX: --error=outputs/errors.e%j
#FLUX: -n 1
#FLUX: --cores-per-task=28
#FLUX: -t 1d

ulimit -v unlimited
ulimit -s unlimited
ulimit -u 1000

module load cuda10.0/toolkit/10.0.130 # loading cuda libraries/drivers 
module load python/intel/3.7          # loading python environment

python3 train_cnn_script.py
