#!/bin/bash
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --queue=gpu2
#FLUX: --gpus-per-task=1
# Note: This script is intended to be run as a job array, e.g., 'flux submit --cc=0-9 ...'
# The Slurm output pattern '%A_%a' is translated using Flux environment variables.
#FLUX: --output=resnet50-bs128_${FLUX_JOB_ID}_${FLUX_JOB_CC}.log

# The SLURM directive '--mem-per-cpu=8000' has no direct equivalent in the provided flux submit options.
# This may result in the job using default memory allocation, potentially affecting performance or causing failure if it exceeds limits.

cd /home/steinba/development/deeprace/
pwd
module load modenv/both modenv/eb tensorflow/1.3.0-Python-3.5.2 docopt/0.6.2 keras/2.1.4 h5py/2.6.0-intel-2016.03-GCC-5.3-Python-3.5.2-HDF5-1.8.17-serial

# Using 'flux run' is the recommended way to launch tasks under Flux.
# SLURM_ARRAY_JOB_ID and SLURM_ARRAY_TASK_ID are replaced with their Flux equivalents.
flux run -n 1 python3 ./deeprace.py train -O batch_size=128 -c "k80:1,fs:nfs" -t /home/steinba/development/deeprace/scripts/short/resnet56v1-short-bs128-${FLUX_JOB_ID}_${FLUX_JOB_CC}.tsv -e 15 resnet56v1
