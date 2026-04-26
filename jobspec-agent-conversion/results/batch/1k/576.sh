#!/bin/bash

#FLUX: --nodes=1
#FLUX: --time-limit=48h
#FLUX: --job-name=haryana
#FLUX: --cwd=.

# start job from the directory it was submitted

module load python/3.4

export PATH=$HOME/bin:$PATH

perl -Mlocal::lib -I$HOME/perl5/lib/perl5 control.pl $FLUX_JOB_CC
