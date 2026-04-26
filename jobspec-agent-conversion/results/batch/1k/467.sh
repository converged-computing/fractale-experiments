#!/bin/sh
#FLUX: --time-limit=8h
#FLUX: --output=/usr/users/scarste/lfs_out/out.%J
#FLUX: --ntasks=41

# The LSF directives -a (application type) and -R (resource requirement) have no direct analogs in Flux.
# The -q (queue) directive was ignored as per instructions.
# LSF filename substitutions (%J) are not supported by Flux.

source ~/.bashrc
module purge
module load intel/compiler
module load intel/mkl
module load openmpi/gcc
module load python/site-modules

export OMPI_MCA_btl_openib_ib_timeout=28

config_file=~/projects/ensemble_hic/scripts/proteins/config.cfg

python -u ~/projects/ensemble_hic/scripts/run_simulation.py $config_file
