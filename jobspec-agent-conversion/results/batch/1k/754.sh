#!/bin/bash

#FLUX: --time-limit=1d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --job-name=training-run-continue
#FLUX: --gpus-per-task=2
#FLUX: --requires=k40

STYLEGAN_PATH=/your/path/to/stylegan

module load TensorFlow/1.10.1-fosscuda-2018a-Python-3.6.4

cd $STYLEGAN_PATH

source venv/bin/activate

python train.py
