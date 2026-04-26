#!/usr/bin/env bash

#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --job-name=dask_cuda_cupy_cluster
#FLUX: --output=dask_cuda_cupy_cluster.o
#FLUX: --error=dask_cuda_cupy_cluster.e

PROJ_ID=stf011

module load gcc/6.4.0
module load cuda/10.1.168

export PATH=$WORLDWORK/stf011/nvrapids_0.11_gcc_6.4.0/bin:$PATH
export CUPY_CACHE_DIR=$MEMBERWORK/$PROJ_ID
export OMP_PROC_BIND=FALSE

dask-scheduler --interface ib0 --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler-gpu.json --local-directory $MEMBERWORK/$PROJ_ID &

flux run -n 1 -c 1 -g 6 dask-cuda-worker --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler-gpu.json  --local-directory $MEMBERWORK/$PROJ_ID  --nthreads 1 --memory-limit 85GB --device-memory-limit 16GB  --death-timeout 60 --interface ib0 --enable-nvlink

