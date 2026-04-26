#!/bin/bash
  
#FLUX: --nodes=1
#FLUX: --ntasks=64
#FLUX: --time-limit=3h50m
#FLUX: --output=paraview.out
#FLUX: --error=paraview.out

module purge
module load conda
source activate an
module load paraview/5.11

# mpiexec is replaced by 'flux run'. The number of tasks is taken from the job spec.
flux run -n 64 pvserver --connect-id=11111 --displays=0
