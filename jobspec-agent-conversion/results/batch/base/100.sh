#!/bin/bash

#
# In order to submit this job to Flux, run the command below from the terminal.
# `flux submit ./submit.sh`

#FLUX: --time-limit=8h
#FLUX: --queue=batch
#FLUX: --nodes=1
#FLUX: --requires=cascade
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --job-name=prob142
#FLUX: --output=prob142-{id}.out
#FLUX: --error=prob142-{id}.err

# The --mem=24G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.

#-------- End of Flux commands -------------------------

module load rust 

cargo run --release
