#!/bin/bash
#FLUX: --time-limit=6h
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=128
#FLUX: --gpus-per-task=1


module load tensorflow/2.6.0
# The srun command is not required for a single-task job in Flux.
python /global/homes/b/bid13/provabgs/bin/emulator.py nmf 100 0 50 8 256 2048
