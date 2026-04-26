#!/bin/bash
### set the number of nodes and the number of PEs per node
#FLUX: --nodes=64
#FLUX: --tasks-per-node=16
#FLUX: --exclusive
### which queue/account to use
#FLUX: --queue=high
### set the wallclock time
#FLUX: --time-limit=1h
### set the job name
#FLUX: --job-name=select_neurotrees
### set the job stdout and stderr
#FLUX: --error=./results/neurotrees_select.{id}.err
#FLUX: --output=./results/neurotrees_select.{id}.out

# The PBS directive '-W umask=0027' has no Flux equivalent.
# To replicate this behavior, you can add 'umask 0027' to the script body.

module swap PrgEnv-cray PrgEnv-gnu
module load cray-hdf5-parallel

set -x

# The PBS command 'aprun' has been replaced with 'flux run'.
flux run -n 1024 ./build/neurotrees_select -p GC -i 256 --reindex \
      --cachesize=$((4 * 1024 * 1024)) \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_extended_20171019_compressed.h5 \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_reindex_20170615.dat \
      /projects/sciteam/baef/Full_Scale_Control/DGC_forest_20171019.h5
