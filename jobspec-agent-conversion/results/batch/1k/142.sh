#!/bin/bash
#FLUX: --job-name=baseline-torch  
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32         
#FLUX: --gpus-per-task=1
#FLUX: --time=30m

# NOTE: --mem and specific GPU model requests are not supported.

# Activate your conda environment
source $STORE/mytorchdist/bin/deactivate

source $STORE/mytorchdist/bin/activate

# Run (BASELINE.py) with one GPU
which python
python lightningDDP_v2.py
