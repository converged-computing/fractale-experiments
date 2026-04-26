#!/bin/bash
#FLUX: --time-limit=10h
#FLUX: --cores=656
#FLUX: --output=job.out
#FLUX: --error=job.out

module load intel-fc
module load intel-cc
module load netcdf
module load openmpi/1.10.2
export PYTHONPATH=/short/m68/kaa561/metroms_iceshelf/apps/common/python:$PYTHONPATH
export LD_LIBRARY_PATH=/apps/netcdf/4.2.1.1/lib/Intel:/apps/openmpi/1.10.2/lib/Intel:$LD_LIBRARY_PATH

ulimit -s unlimited
if [ -e /short/m68/kaa561/metroms_iceshelf/tmproms/run/circumpolar/oceanM ]; then
    python circumpolar.py
    echo "Done"
else
    echo "Problem with compilation"
fi
