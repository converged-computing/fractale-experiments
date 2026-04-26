#!/bin/bash
#FLUX: -q gpuvolta
#FLUX: -B e14
#FLUX: --cores=12
#FLUX: --gpus-per-node=1
#FLUX: -t 24h
#FLUX: --cwd=.

# NOTE: The PBS directive 'mem=96GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The PBS directive 'jobfs=1GB' was omitted as it is a site-specific feature with no Flux equivalent.
# NOTE: The PBS directive 'storage=...' was omitted as it is a site-specific feature with no Flux equivalent.
# NOTE: The PBS directive for email notification ('-M') was omitted as there is no Flux equivalent.

cd /g/data/e14/jb2381/CabbelingExperiments/

# Julia
export JULIA_DEPOT_PATH="/home/561/jb2381/.julia"
export JULIA_NUM_THREADS=auto
module load julia

# Run the experiment
# The PBS job ID variable has been replaced with the Flux equivalent.
julia --project isothermal_gpu_salinitynoise.jl > $FLUX_JOB_ID.log
