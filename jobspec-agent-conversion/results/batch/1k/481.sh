#!/bin/bash

#
# In order to submit this job to Flux, run the command below from the terminal.
#   flux submit submit.sh

#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --requires=48core
#FLUX: --ntasks=1
#FLUX: --cores-per-task=48
#FLUX: --job-name=prob111
#FLUX: --output=prob111-{id}.out
#FLUX: --error=prob111-{id}.err

#-------- End of Flux commands -------------------------

module load rust 

cargo run --release
