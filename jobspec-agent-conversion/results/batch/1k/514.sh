#!/bin/bash
#FLUX: --job-name=resnet-within
#FLUX: --output=debug/resnet-within.%j.out
#FLUX: --error=debug/resnet-within.%j.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=2h

# The Slurm directive to exclude nodes (-x) has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style job ID substitution (%j).
# The SLURM_JOB_NODELIST environment variable has been replaced by FLUX_JOB_NODELIST.

node=$FLUX_JOB_NODELIST
module load tacc-apptainer
echo "Node Number: ${node}"
resnet-singularity-multi.sh
