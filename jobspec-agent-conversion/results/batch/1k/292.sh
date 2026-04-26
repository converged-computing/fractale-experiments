#!/bin/bash
#FLUX: --time-limit=30m
#FLUX: --output=python_array_%a.out

# NOTE: The %a format specifier is not supported in Flux; files will be overwritten.
# NOTE: This script is intended to be run as a job array. You must submit it with 'flux submit --cc=1-100 ...'

module load scicomp-python-env # use the normal scicomp environment for python

# srun is not required for a single task job in Flux
python serial.py
