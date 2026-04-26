#!/bin/bash

#FLUX: --job-name=mapar
#FLUX: --time-limit=48h
#FLUX: --cc=1-104
#FLUX: --requires=hpcwork
#FLUX: --output=arrayjob.out

# The LSF memory request (-M 2000) has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# LSF-style output file name substitutions (%J, %I) are not supported.
# All jobs in the collection will write to the same output file.

export LIBPATH=/home/lf216591/perl5/lib/perl5
export PERL5LIB=/home/lf216591/perl5/lib/perl5
export LD_PRELOAD=/opt/MPI/openmpi-1.10.2/linux/intel_16.0.2.181/lib/libmpi.so

cd /work/lf216591/07_pleo_para_annot/01_parauncinula/01_paraunc_annotation/01_maker

./run_maker.sh
