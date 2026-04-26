#!/bin/bash
#FLUX: --nodes=64
#FLUX: --tasks-per-node=16
#FLUX: --requires=xe
#FLUX: --time-limit=1h
#FLUX: --job-name=select_neurotrees
#FLUX: --error=./results/neurotrees_select.err
#FLUX: --output=./results/neurotrees_select.out

# The PBS directive '-W umask=0027' could not be translated.
# The dynamic filenames using $PBS_JOBID are not supported.

module swap PrgEnv-cray PrgEnv-gnu
module load cray-hdf5-parallel

set -x

# The $PBS_O_WORKDIR variable is not needed; Flux starts in the submission directory.

# The aprun command has been replaced with flux run.
flux run -n 1024 ./build/neurotrees_select -p GC -i 256 --reindex \
      --cachesize=$((4 * 1024 * 1024)) \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_extended_20171019_compressed.h5 \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_reindex_20170615.dat \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_20171019.h5
