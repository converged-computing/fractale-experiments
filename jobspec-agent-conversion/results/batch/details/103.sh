#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=2
#FLUX: --gpus-per-node=1
#FLUX: --requires=k80
#FLUX: --time-limit=24h
#FLUX: --job-name=nott-STR-MLP

# The following PBS directives could not be translated:
# -l mem=16GB
# -j oe

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
THEANO_FLAGS="lib.cnmem=1.,scan.allow_gc=False,compiledir_format=gpu0" python2.7 train_dkf.py -vm R -infm structured -ttype mlp -dset nottingham-sorted
