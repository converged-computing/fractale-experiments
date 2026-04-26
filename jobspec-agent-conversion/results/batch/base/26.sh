#!/bin/bash
#FLUX: --queue=prod
#FLUX: --job-name=XXXXXX
#FLUX: --time-limit=12h
#FLUX: --tasks-per-node=24
#FLUX: --output=XXXXXX.out

module load openmpi
module load gromacs/5.1.4-single

mpirun gmx_mpi mdrun -deffnm XXXXXX
