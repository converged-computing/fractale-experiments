#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h
#FLUX: --job-name=piano-ARAUG
# The '-j oe' PBS option is achieved by setting output and error to the same file.
#FLUX: --output=piano-ARAUG.out
#FLUX: --error=piano-ARAUG.out

# The PBS directive '-l mem=16GB' has no direct equivalent in the provided flux submit options.
# This may result in the job using default memory allocation, potentially affecting performance or causing failure if it exceeds limits.
# The PBS request for a 'k80' GPU is a feature request. In Flux, this might be specified with a constraint, e.g., #FLUX: --requires=gpu:k80
# The PBS directive '-M' for email notification has no direct equivalent and has been omitted.

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

# Using 'flux run' is the recommended way to launch tasks under Flux.
flux run -n 1 THEANO_FLAGS="lib.cnmem=1.,scan.allow_gc=False,compiledir_format=gpu1" python2.7 train_dkf.py -vm R -infm structured -ar 5000 -etype conditional -previnp -dset piano-sorted  -bs 10 -dh 100 -ds 50
