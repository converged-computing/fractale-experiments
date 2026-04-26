#!/bin/bash
#FLUX: -t 5m
#FLUX: -N 1
#FLUX: -n 8
#FLUX: --job-name=AMG2013-PROFMPI
#FLUX: --output=output.AMG2013-PROFMPI
#FLUX: --error=error.AMG2013-PROFMPI


hpcstruct -j 8 AMG2013/test/amg2013

ranks=8

# jsrun has been replaced with flux mini run
flux mini run -n $ranks \
    hpcprof-mpi -S amg2013.hpcstruct \
		--metric-db yes \
		-o hpctoolkit-amg2013.d \
		hpctoolkit-amg2013.m

