#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=2
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=24h
#FLUX: --job-name=piano-MFLR

# The PBS memory request (-l mem) has no direct analog in flux and has been omitted.
# The PBS request for a specific GPU model (:k80) is not supported; only the count is used.
# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.

module purge
module load node
module load cmake
module load python/intel/2.7.6
module load numpy/intel/1.9.2
module load hdf5/intel/1.8.12
module load cuda/7.5.18
module load cudnn/7.0

RUNDIR=$SCRATCH/structuredinference/expt-polyphonic
cd $RUNDIR
THEANO_FLAGS="lib.cnmem=0.9,scan.allow_gc=False,compiledir_format=compiledir_format=compiledir_%(platform)s-%(processor)s-%(python_version)s-%(python_bitwidth)s-1" python train_dkf.py -vm LR -infm mean_field -dset piano-sorted
