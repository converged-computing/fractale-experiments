#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=1h
#FLUX: --cwd=.

#
# Example (single-core) MATLAB job script
# see http://hpcugent.github.io/vsc_user_docs/
#

# make sure the MATLAB version matches with the one used to compile the MATLAB program!
module load MATLAB/2021b

# use temporary directory (not $HOME) for (mostly useless) MATLAB log files
# subdir in $TMPDIR (if defined, or /tmp otherwise)
export MATLAB_LOG_DIR=$(mktemp -d -p  ${TMPDIR:-/tmp})

# configure MATLAB Compiler Runtime cache location & size (1GB)
# use a temporary directory in /dev/shm (i.e. in memory) for performance reasons
export MCR_CACHE_ROOT=$(mktemp -d -p /dev/shm)
export MCR_CACHE_SIZE=1024MB

# run compiled example MATLAB program 'example', provide '5' as input argument to the program
# $EBROOTMATLAB points to MATLAB installation directory
./run_example.sh $EBROOTMATLAB 5

