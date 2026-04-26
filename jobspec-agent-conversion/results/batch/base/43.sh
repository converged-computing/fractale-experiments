#!/bin/sh
# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.
# This script is designed to be run as part of a Flux job collection (e.g., 'flux submit --cc=...').
# The SLURM_ARRAY_TASK_ID variable has been replaced with FLUX_JOB_CC.

matlab -nodisplay '+single_thread+' '+jvm_string+' -nodesktop -r "addpath('../scripts/matlab/');, run_selective_search(${FLUX_JOB_CC});"
