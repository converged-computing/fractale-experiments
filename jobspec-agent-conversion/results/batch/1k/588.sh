#!/usr/bin/env zsh

#FLUX: --job-name=OpenMPI36
#FLUX: --output=OpenMPI36.%J
#FLUX: --time-limit=6h
#FLUX: --ntasks=2

module load TECHNICS
module load openfoam/5.0

### Execute your application
# The LSF MPI launch command ($MPIEXEC $FLAGS_MPI_BATCH) has been replaced with the standard Flux MPI launcher.
flux mini run -n 2 foamExec CoMeTFoam -parallel
