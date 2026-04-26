#!/bin/bash
#FLUX: --job-name=gw_amr
#FLUX: --bank=vp91
#FLUX: --queue=normal
#FLUX: --time-limit=20m
#FLUX: --ntasks=16
#FLUX: --cwd=.

# The PBS directive '#PBS -l mem=64gb' has no direct equivalent in the provided flux submit options.
# This may result in the job using default memory allocation, potentially affecting performance or causing failure if it exceeds limits.

# Assuming modules.sh and the project are in the submission directory.
# The $PBS_O_WORKDIR variable is replaced with '.'
source ./modules.sh

flux run -n 16 julia --project=. -e'
  using GadiTutorial;
  main_amr(;nprocs=16,nrefs=4,num_amr_steps=6)
'
