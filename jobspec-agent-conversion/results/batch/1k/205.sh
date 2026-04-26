#!/bin/bash
#FLUX: --job-name=DeepForest_cpu
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=5
#FLUX: --time-limit=24h
#FLUX: --output=/home/b.weinstein/logs/DeepForest_cpu.out
#FLUX: --error=/home/b.weinstein/logs/DeepForest_cpu.err

# The --mem-per-cpu=5GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --account and --mail directives were ignored as per instructions.

ml git
ml gcc
ml gdal
ml tensorflow/1.7.0
export PYTHONPATH=${PYTHONPATH}:/home/b.weinstein/miniconda3/envs/DeepForest/lib/python3.6/site-packages/
echo $PYTHONPATH


cd /home/b.weinstein/DeepForest

python train.py
