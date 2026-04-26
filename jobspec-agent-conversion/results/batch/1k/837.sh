#!/bin/bash
#FLUX: --time-limit=20m
#FLUX: --cores=4
#FLUX: --ntasks=4
#FLUX: --job-name=gw_poisson
#FLUX: --cwd=.

source ./modules.sh

# The 'mpiexec' command has been replaced by the standard Flux launcher 'flux mini run'.
# The $PBS_O_WORKDIR variable is replaced by '.' since the working directory is set to the submission directory.
flux mini run -n 4 julia --project=. -J./GadiTutorial.so -e'
  using GadiTutorial;
  main_poisson(;nprocs=(2,2),ncells=(100,100))
'
