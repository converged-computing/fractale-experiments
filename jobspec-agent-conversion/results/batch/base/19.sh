#!/bin/bash

#FLUX: --nodes=64
#FLUX: --job-name=2048_acoustics
#FLUX: --output=2048_acoustics.out
#FLUX: --bank=k1069
#FLUX: --time-limit=3h
#FLUX: --ntasks=2048
#FLUX: --cores-per-task=1
#FLUX: --tasks-per-node=32


# The detailed srun options for task binding (--hint, --ntasks-per-socket, --cpu_bind)
# have no direct equivalents in flux run. Performance may differ.

echo job running on...
hostname

module load python/.pyclaw_64bits_493

export OMP_NUM_THREADS=1
export PYTHONPATH=/project/k1069/lib/python2.7/site-packages:$PYTHONPATH

# The Slurm srun command has been replaced with flux run.
# Flux will distribute the 2048 tasks across the 64 nodes (32 tasks per node).
flux run python ../acoustics_3d_scaling.py -s strong -x 256 use_petsc=1
