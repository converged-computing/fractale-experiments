#!/bin/bash

#
# In order to submit this job to Flux, run the command below from the terminal.
# `flux submit ./submit.sh`

#FLUX: --time-limit=8h
#FLUX: --nodes=1
#FLUX: --requires=cascade
#FLUX: --cores-per-task=4
#FLUX: --job-name=prob142
#FLUX: --output=prob142.out
#FLUX: --error=prob142.err

# The SLURM directive '--mem=24G' could not be translated.

#-------- End of Flux commands -------------------------

module load rust 

cargo run --release
