#!/bin/bash

#FLUX: --job-name=paraview
#FLUX: --mail-type=NONE
#FLUX: --ntasks=48
#FLUX: --time=2d20h
#FLUX: --output=%x-%j.log


# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

echo "Working Directory = $(pwd)"

# cd $SLURM_SUBMIT_DIR # This is the default behavior in Flux
export PROG="pvserver --force-offscreen-rendering"
module load paraview 

# 'srun' is replaced with 'flux run'
flux run -n 48 $PROG
