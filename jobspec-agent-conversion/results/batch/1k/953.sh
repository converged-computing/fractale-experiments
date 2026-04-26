#!/usr/bin/env bash

#FLUX: --time-limit=1h
#FLUX: --nodes=4
#FLUX: --job-name=dask_cluster
#FLUX: --output=dask_cluster.o
#FLUX: --error=dask_cluster.e

PROJ_ID=stf011

module load gcc/6.4.0
module load cuda/10.1.168

export PATH=$WORLDWORK/stf011/nvrapids_0.11_gcc_6.4.0/bin:$PATH

dask-scheduler --interface ib0 --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler.json --local-directory $MEMBERWORK/$PROJ_ID/scheduler &

flux run -n 4 -c 42 -g 6 dask-worker --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler.json --nthreads 42  --memory-limit 512GB  --nanny --death-timeout 60 --interface ib0 --local-directory $MEMBERWORK/$PROJ_ID/worker

