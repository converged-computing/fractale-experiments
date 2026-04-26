#!/bin/bash

echo "Bash version ${BASH_VERSION}..."

#FLUX: --nodes=1
#FLUX: --time-limit=4h
#FLUX: --job-name=cluster_analysis_classic_preproc

MATLAB=/usr/local/MATLAB/R2017a/bin/matlab

# The original script took the working directory as a command-line argument ($1).
# This behavior is preserved.
FLUX_O_WORKDIR=$1

echo Working directory is $FLUX_O_WORKDIR
cd $FLUX_O_WORKDIR

# The number of cores allocated to the job can be accessed via FLUX_JOB_NCORES
NPROCS=$FLUX_JOB_NCORES

echo This job has allocated $NPROCS cpus

# The original script took the matlab script name as a command-line argument ($2).
# This behavior is preserved.
matlab_script=$2


$MATLAB -nojvm -nodisplay -nosplash -r "${matlab_script}; exit"
