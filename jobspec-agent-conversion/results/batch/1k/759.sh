#!/bin/bash
#FLUX: --job-name=E1A
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --time-limit=40h

# The --mem=8GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

source /scratch/work/courses/CHEM-GA-2671-2022fa/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
gmx_mpi mdrun -s topolA.tpr -nsteps 5000000 -plumed plumed.dat
