#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --gpus-per-node=1
#FLUX: --output=output/{id}.out
#FLUX: --error=output/{id}.err
python custom_cnn.py
