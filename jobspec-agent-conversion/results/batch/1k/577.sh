#!/bin/bash

#FLUX: --nodes=1
#FLUX: --time-limit=5d
#FLUX: --job-name=up





# use submission environment
# NOTE: -V flag is not supported in Flux

# start job from the directory it was submitted
module unload python
module load python/3.3
module load tesseract/svn__19-May-2014

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

# NOTE: This script is a job array. The PBS_ARRAYID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with a --cc flag.
perl -Mlocal::lib=$HOME/perl5-hal -I$HOME/perl5-hal/lib/perl5 control.pl $FLUX_JOB_CC
