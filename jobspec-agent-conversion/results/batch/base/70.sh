#!/bin/bash

#FLUX: --job-name=example
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5m
#FLUX: --queue=alpha
#FLUX: --output=${FLUX_JOB_ID}.out

# The SLURM directive '--mem=2GB' has no direct equivalent in the provided flux submit options.
# This may result in the job using default memory allocation, potentially affecting performance or causing failure if it exceeds limits.

module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 PyTorch/1.10.0 tqdm/4.56.2

myworkspace="$(ws_find myworkspace)"

# Using 'flux run' is the recommended way to launch tasks under Flux.
flux run -n 1 python "$myworkspace"/src/myscript.py
