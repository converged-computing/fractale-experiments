#!/bin/bash
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=resnet50-bs128.log

cd /home/steinba/development/deeprace/
pwd
module load modenv/both modenv/eb tensorflow/1.3.0-Python-3.5.2 docopt/0.6.2 keras/2.1.4 h5py/2.6.0-intel-2016.03-GCC-5.3-Python-3.5.2-HDF5-1.8.17-serial

# The SLURM array variables have been replaced with their Flux equivalents.
# This script should be submitted with the 'flux submit --cc=...' flag for these variables to be populated.
python3 ./deeprace.py train -O batch_size=128 -c "k80:1,fs:nfs" -t /home/steinba/development/deeprace/scripts/short/resnet56v1-short-bs128-${FLUX_JOB_ID}_${FLUX_JOB_CC}.tsv -e 15 resnet56v1
