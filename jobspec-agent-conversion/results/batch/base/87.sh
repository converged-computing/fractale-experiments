#!/bin/bash

# Submit the pipeline as a job with srun job.sh

# Modified from https://github.com/mschubert/clustermq/blob/master/inst/LSF.tmpl
# under the Apache 2.0 license:
#FLUX: --job-name=soy_test_alignment
#FLUX: --output=/dev/null
#FLUX: --error=/dev/null
#FLUX: --cores-per-task=1
#FLUX: --nodes=1
#FLUX: --ntasks=72
#FLUX: --exclusive
#FLUX: --time-limit=12h

# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.
# The SLURM --mail-user and --mail-type directives have no direct Flux analog.

module load singularity
singularity exec conda.sif R CMD BATCH run.R

# Removing .RData is recommended.
# rm -f .RData
