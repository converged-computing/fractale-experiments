#!/bin/bash
#FLUX: --nodes=15
#FLUX: --tasks-per-node=16
#FLUX: --ntasks=240
#FLUX: --time-limit=3d
#FLUX: --output=matrix_gen
#FLUX: --job-name=graphmmp

# NOTE: The -j oe (join output/error) option is not supported.


HOST=$(echo $LST | cut -d '.' -f1).host
LOG=$(echo $LST | cut -d '.' -f1).log

cd /work/jfeins1/mastro/

module load gnuparallel/20180222/INTEL-18.0.0

# Create a hostfile for parallel using flux resource list
flux resource list > /work/jfeins1/maestro/$HOST

# Use flux run to launch the parallel command
flux run -n 240 parallel --jobs 16 --wd /work/jfeins1/maestro/ --joblog /work/jfeins1/maestro/$LOG --resume --colsep ' ' -a /work/jfeins1/maestro/$LST sh /work/jfeins1/maestro/python_wrapper_gen_encoding.sh {}

rm /work/jfeins1/maestro/$HOST
