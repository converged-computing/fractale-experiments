#!/bin/bash
#FLUX: --job-name=ior_n64
#FLUX: --time-limit=2h
#FLUX: --nodes=64
#FLUX: --ntasks=64
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1

export TMPDIR=/glade/scratch/$USER/tmp
mkdir -p $TMPDIR

module restore ncar-ior
export LD_LIBRARY_PATH=/glade/work/kpaul/software/boost/lib:$LD_LIBRARY_PATH

./scripts/runtest.sh 64 4 5 0 5
