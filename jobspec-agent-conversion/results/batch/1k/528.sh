#!/bin/bash -l
#
#FLUX: --job-name="1d_sedentary"
#FLUX: --time-limit=23h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

# The --mem-per-cpu=96G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

module load 2022r1
module load gpu
module load python/3.8.12-bohr45d
module load openmpi
module load py-tensorflow




python Model1D2S_SEDENTARY.py
