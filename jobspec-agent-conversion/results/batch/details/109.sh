#!/bin/bash -l
# The PBS resource request is translated to the following flux directives:
#FLUX: --time-limit=96h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=13
# The mem=2580mb directive has no direct flux analog and is omitted.
# The -m and -M mail directives are ignored as per instructions.

cd ~/kitaev
module load matlab
matlab -nodisplay -r "maxNumCompThreads(13)" < do_some_mcmc.m
