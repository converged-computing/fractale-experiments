#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h

# The following PBS directives could not be translated:
# -l mem=96GB
# -l jobfs=1GB
# -l storage=gdata/e14+scratch/e14

cd /g/data/e14/jb2381/CabbelingExperiments/

# Julia
export JULIA_DEPOT_PATH="/home/561/jb2381/.julia"
export JULIA_NUM_THREADS=auto
module load julia

# Run the experiment
# The PBS variable $PBS_JOBID has been replaced with the Flux equivalent.
julia --project isothermal_gpu_salinitynoise.jl > $FLUX_JOB_ID.log
