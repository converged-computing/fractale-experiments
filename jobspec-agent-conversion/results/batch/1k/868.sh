#!/bin/bash

#FLUX: --job-name=lammps
#FLUX: --nodes=8
#FLUX: --tasks-per-node=8
#FLUX: --time-limit=4h

# The --mem=8GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

source /scratch/work/courses/CHEM-GA-2671-2022fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

mpirun lmp -var density 0.5 -in ../Inputs/2dWCA.in
