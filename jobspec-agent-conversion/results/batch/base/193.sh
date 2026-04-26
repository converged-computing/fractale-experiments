#!/bin/bash -l
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --tasks-per-node=24
#FLUX: --gpus-per-node=2

# The PBS memory request 'mem=125gb' has no direct Flux analog in the provided documentation.
# The PBS email notification directives '-m' and '-M' have no direct Flux analog.

cd ~/Forest
module load python2
source activate installs
module load cuda/9.0
python play_bmsb.py
