#!/bin/bash

# JOB HEADERS HERE

#FLUX: --job-name=run-gromacs
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --time-limit=4h


module load gromacs/openmpi/intel/2018.3

# 'gmx_mpi' is an MPI application, so it should be launched with 'flux run'
flux run -n 1 gmx_mpi grompp -f adp_T350.mdp -c adp.gro  -p adp.top -o adp_T350.tpr
flux run -n 1 gmx_mpi mdrun -deffnm adp_T350
