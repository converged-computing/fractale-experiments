#!/bin/sh
# The --mem-per-cpu=6G directive has no direct flux analog and is omitted.
# This script is intended to be run as part of a job array, e.g., `flux submit --cc=1-N script.sh`

matlab -nodisplay '+single_thread+' '+jvm_string+' -nodesktop -r "addpath('../scripts/matlab/');, run_selective_search(${FLUX_JOB_CC});"
