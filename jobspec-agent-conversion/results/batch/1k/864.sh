#!/bin/bash
# This script expects one argument: the dsnumber, e.g., ds000001

# Ensure a dsnumber is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a dsnumber as the first argument." >&2
  exit 1
fi

path="/expanse/projects/nemar/openneuro/processed/logs"

#FLUX: --job-name=$1
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --output=${path}/$1.out
#FLUX: --error=${path}/$1.err
#FLUX: --time-limit=48h

# The --mem=240G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --no-requeue directive has no direct analog in the provided flux submit options.

cd /home/dtyoung/NEMAR-pipeline
module load matlab/2022b
matlab -nodisplay -r "run_pipeline('$1', 'maxparpool', 4, 'modeval', 'resume');"
