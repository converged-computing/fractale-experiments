#!/bin/bash -l
#FLUX: --time-limit=96h
#FLUX: --nodes=1
#FLUX: --cores=13
#FLUX: --ntasks=1

# The PBS memory request 'mem=2580mb' has no direct Flux analog in the provided documentation.
# The PBS email notification directives '-m' and '-M' have no direct Flux analog.

cd ~/kitaev
module load matlab
matlab -nodisplay -r "maxNumCompThreads(13)" < do_some_mcmc.m
