#!/bin/bash

#FLUX: --nodes=2
#FLUX: --job-name=HDF5
#FLUX: --time-limit=60m

# The following PBS directives had no direct analog and were omitted:
# -l select=...:system=polaris,place=scatter
# -l filesystems=home
# -k doe

module load e4s/22.08
module load cmake

export CXX=gcc

cd /lus/grand/projects/CSC250STDM10/hyoklee/hdf5/build
/home/hyoklee/src/hpc-h5/bin/ctt
