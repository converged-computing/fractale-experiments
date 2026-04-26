#!/bin/bash -l
#FLUX: --job-name=make-env
#FLUX: --time-limit=30m
#FLUX: --nodes=1

# The PBS memory request (-l pmem) has no direct analog in flux and has been omitted.
# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.

# this actually uses mamba, which is a fast reimplementation of conda
# don't worry about these details

module load python/3.6.3-anaconda5.0.1
cd /gpfs/group/kzk10/default/private/rnetcdf-demo/2020-PSU-ACI-rnetcdf
conda env create --file environment.yml
source deactivate
