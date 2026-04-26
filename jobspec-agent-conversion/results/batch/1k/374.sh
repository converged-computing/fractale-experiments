#!/usr/bin/env bash

#FLUX: --time-limit=1h
#FLUX: --nodes=4
#FLUX: --job-name=dask_ucx_cluster
#FLUX: --output=dask_ucx_cluster.o{id}
#FLUX: --error=dask_ucx_cluster.e{id}
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=42
#FLUX: --gpus-per-node=6

PROJ_ID=stf011

module load gcc/6.4.0
module load cuda/10.1.168

export PATH=$WORLDWORK/stf011/nvrapids_0.11_gcc_6.4.0/bin:$PATH

dask-scheduler --interface ib0 --protocol ucx --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler.json --local-directory $MEMBERWORK/$PROJ_ID/scheduler &

flux mini run -n 4 dask-worker --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler.json --nthreads 42  --memory-limit 512GB  --nanny --death-timeout 60 --interface ib0 --protocol ucx --local-directory $MEMBERWORK/$PROJ_ID/worker
