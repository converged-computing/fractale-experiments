#!/bin/bash
#FLUX: --job-name=PMDA_BM
#FLUX: --nodes=6
#FLUX: --tasks-per-node=12
#FLUX: --time-limit=8h

# The original script did not specify a memory request.
                      
bash /home/sfan19/.bashrc

echo $FLUX_JOB_ID
echo $USER

# Start the Dask scheduler on the initial node.
SCHEDULER=`hostname`
echo SCHEDULER: $SCHEDULER
dask-scheduler --port=8786 &
sleep 5

# Use 'flux exec' to start dask-workers on all other allocated nodes.
# This is the idiomatic way to launch services across the job in Flux.
flux exec -x 0 dask-worker --nprocs 12 --nthreads 1 $SCHEDULER:8786 &
sleep 10 # Give workers time to register


python benchmark_rms_distr.py /scratch/$USER/$FLUX_JOB_ID $SCHEDULER:8786
