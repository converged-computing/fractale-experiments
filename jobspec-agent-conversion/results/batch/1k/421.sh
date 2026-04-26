#!/bin/bash

#FLUX: --exclusive
#FLUX: --nodes=1
#FLUX: --job-name=dask-worker
#FLUX: --time-limit=6h
#FLUX: --ntasks=6
#FLUX: --cores-per-task=4

# Writes ~/scheduler.json file in home directory
# Connect with
# >>> from dask.distributed import Client
# >>> client = Client(scheduler_file='~/scheduler.json')

# Setup Environment
module load anaconda
source activate pangeo

# memory-limit is per process
# since we use six processes, we request approx 1/6 of system memory
# 0.15 < 0.1666666

LDIR=/local/$USER
rm -rf $LDIR

SCHEDULER=$HOME/scheduler.json
flux run -n 6 dask-mpi --nthreads 4 \
    --memory-limit 0.15 \
    --interface ib0 \
    --no-scheduler --local-directory $LDIR \
    --scheduler-file=$SCHEDULER

