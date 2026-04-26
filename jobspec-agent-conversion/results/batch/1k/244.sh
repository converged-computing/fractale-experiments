#!/bin/bash
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --job-name=galaxy
#FLUX: --output=galaxy.%J.out
#FLUX: --error=galaxy.%J.err

# Flux jobs are typically started in the submission directory, so 'cd $LSB_OUTDIR' is not needed.
date

module load python hdf5 gcc

source activate $HOME/.conda/envs/h5pympi-summit

# The LSF 'jsrun' command has been replaced by the standard Flux launcher.
# The resource request of -n1 (1 task) and -c8 (8 cores) is honored.
flux mini run -n 1 -c 8 python3 -u galaxy.py
