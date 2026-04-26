#!/bin/sh
#######################################
# Specify nodes, processors per node
# and maximum running time
#######################################

#FLUX: --job-name=xxxNAMExxx
#FLUX: --nodes=xxxNODESxxx
#FLUX: --tasks-per-node=xxxPPNxxx
#FLUX: --ntasks=XXXTOTAL_TASKSXXX
#FLUX: --time-limit=xxxWTxxx

# NOTE: Memory request `mem=xxxMEMxxxGB` is not supported.

######################################
# Enter directory and set PATH
######################################

# cd $PBS_O_WORKDIR # This is the default behavior in Flux
PATH=$PBS_O_PATH

######################################
# Run OpenMOC - MAKE YOUR CHANGES HERE
######################################

module load gcc
module load mpich2/gnu
python xxxSTRIPxxx

# 'mpiexec' is replaced with 'flux run'
flux run -n XXXTOTAL_TASKSXXX ./xxxEXECUTExxx
