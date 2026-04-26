#!/bin/bash

# Modified from https://github.com/mschubert/clustermq/blob/master/inst/LSF.tmpl
# under the Apache 2.0 license:
#FLUX: --job-name=soy_test_alignment
#FLUX: --output=/dev/null
#FLUX: --error=/dev/null
#FLUX: --nodes=1
#FLUX: --ntasks=72
#FLUX: --cores-per-task=1
#FLUX: --exclusive
#FLUX: --time-limit=12h

# The SLURM directive '--mem-per-cpu=3000' (totaling ~211GB) could not be translated.

module load singularity
singularity exec conda.sif R CMD BATCH run.R

# Removing .RData is recommended.
# rm -f .RData
