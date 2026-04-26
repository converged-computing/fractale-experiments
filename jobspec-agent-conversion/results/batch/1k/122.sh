#!/bin/bash
#FLUX: --job-name=XXXXXX
#FLUX: --time-limit=12h
#FLUX: --tasks-per-node=24
#FLUX: --output=XXXXXX.out

module load openmpi
module load gromacs/5.1.4-single

# The 'mpirun' command has been replaced with 'flux run'.
# The number of tasks is implicitly set to the value of --tasks-per-node.
flux run gmx_mpi mdrun -deffnm XXXXXX
