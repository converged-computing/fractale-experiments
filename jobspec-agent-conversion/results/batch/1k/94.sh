#!/bin/bash

#FLUX: --nodes=1
#FLUX: --job-name=32_Sedov
#FLUX: --output=32_Sedov.out
#FLUX: --time=3h

# NOTE: Binding and placement flags from srun are not translated.

echo job running on...
hostname

module load python/.pyclaw_64bits_493

export OMP_NUM_THREADS=1
export PYTHONPATH=/project/k1069/lib/python2.7/site-packages:$PYTHONPATH

# 'srun' is replaced with 'flux run'. Resource allocation is now based on the Flux directives.
flux run -n 32 python ../../Sedov_3d_scaling.py -s strong -x 256 use_petsc=1
