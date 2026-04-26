#!/bin/bash -l
#FLUX: --time-limit=120h
#FLUX: --cores-per-task=1
#FLUX: --cc=1-200
#FLUX: --output=slurm-%A_%a.out

# The --mem-per-cpu=30G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job array substitutions (%A, %a).
# All jobs in the collection will write to the same file.

module load matlab

matlab_multithread -nodisplay -nosplash -r "WCnet_mixeddelays_noisy_posteriorpredictivechecks($FLUX_JOB_CC) ; exit(0)"
