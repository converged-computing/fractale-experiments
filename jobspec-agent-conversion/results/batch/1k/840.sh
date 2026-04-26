#!/bin/bash

#FLUX: --job-name=ttestgcn
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

module purge
module load python/3.8.2
module load torch/1.7.1-py38-gcc-7.2.0-cuda-10.1-openmpi-4.0.1
module load cuda

python3 ttest_gcn.py
