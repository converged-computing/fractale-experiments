#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=12
#FLUX: --cores-per-task=1
#FLUX: --time-limit=30s
#FLUX: --job-name=Scatter
#FLUX: --bank=PR66
#FLUX: --queue=training

# The PBS memory request 'mem=1MB' has no direct equivalent in flux-submit.

# Load required modules.
module purge
module load python/2.7.9-mpi

# Create an output directory on the fast scratch filesystem, and
# run from this directory.
WDPATH=/scratch/$USER/raven_training/$FLUX_JOB_ID
mkdir -p $WDPATH

# Copy the python code to the run directory
# Assuming the script is submitted from the directory containing scatter.py
cp scatter.py $WDPATH

# Run a number of copies of the code equal to the number of
# MPI processes requested, from the newly created working directory.
flux run -n 12 --cwd=$WDPATH ./scatter.py
