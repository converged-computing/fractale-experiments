#!/bin/bash
#FLUX: --job-name=mmnt-jbf-rand-forst-tox21
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --time-limit=20h


# NOTE: The -j oe (join output/error) option and memory requests are not supported.


# cd $PBS_O_WORKDIR # This is the default behavior in Flux
module load cuda anaconda accelerate
# NOTE: This script is a job array. The PBS_ARRAYID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-11 ...'
python sk_random_forests.py tox21 $FLUX_JOB_CC
