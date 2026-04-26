#!/bin/bash
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=12
# The mem=1MB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=30s
#FLUX: --job-name=Scatter
# The -P PR66 and -q training directives are ignored as per instructions.

# Load required modules.
module purge
module load python/2.7.9-mpi

# Create an output directory on the fast scratch filesystem, and
# run from this directory.
# The PBS_JOBID variable is replaced with FLUX_JOB_ID
WDPATH=/scratch/$USER/raven_training/$FLUX_JOB_ID
mkdir -p $WDPATH
cd $WDPATH

# Copy the python code to the run directory
# The PBS_O_WORKDIR variable is replaced with FLUX_JOB_CWD
cp $FLUX_JOB_CWD/scatter.py .

# Run a number of copies of the code equal to the number of
# MPI processes requested.
# The mpirun command is replaced by `flux mini run`
flux mini run ./scatter.py
