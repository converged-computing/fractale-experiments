#!/bin/bash
#
#FLUX: --job-name=runGA
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --ntasks=4
#FLUX: --output=./headlessOut/%A_%a.out
#FLUX: --error=./headlessOut/%A_%a.err
#FLUX: --time-limit=60d


#NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.


#echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#Load the required modules for Abaqus with fortran
module load MATLAB

./runHeadless.sh MatlabRun
