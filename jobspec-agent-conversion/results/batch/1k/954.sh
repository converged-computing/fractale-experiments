#!/usr/bin/env bash

#FLUX: --time-limit=1h
#FLUX: --nodes=2
#FLUX: --job-name=dask_cuda_worker
#FLUX: --output=dask_cuda_worker.o%J
#FLUX: --error=dask_cuda_worker.e%J

# NOTE: alloc_flags and the %J format specifier are not supported.

PROJ_ID=stf011

module load gcc/6.4.0
module load cuda/10.1.168

export PATH=$WORLDWORK/stf011/nvrapids_0.11_gcc_6.4.0/bin:$PATH

# jsrun is replaced by 'flux run'. Resource allocation is now based on the Flux directives.
# The jsrun flags `-c 42 -g 6 -n 2 -r 1 -a 1` are complex to translate directly.
# This conversion assumes 2 tasks total, one per node, each with 42 cores and 6 gpus.
flux run -n 2 --cores-per-task=42 --gpus-per-task=6 \
    dask-cuda-worker --scheduler-file $MEMBERWORK/$PROJ_ID/my-scheduler-gpu.json  --local-directory $MEMBERWORK/$PROJ_ID  --nthreads 1 --memory-limit 100GB --device-memory-limit 16GB  --death-timeout 60 --interface ib0 --enable-infiniband --enable-nvlink
