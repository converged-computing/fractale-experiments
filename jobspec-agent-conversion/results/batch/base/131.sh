#!/bin/bash
#FLUX: --job-name=PMDA_BM
#FLUX: --queue=compute
#FLUX: --nodes=6
#FLUX: --tasks-per-node=12
#FLUX: --time-limit=8h

# The --export=ALL parameter is default behavior in Flux and is not needed.
# The --mail-type and --mail-user parameters from slurm have no direct equivalent in flux-submit.
                      
bash /home/sfan19/.bashrc

echo $FLUX_JOB_ID
echo $USER

# Get the hostname of the rank 0 task to serve as the scheduler address
SCHEDULER_HOST=$(flux exec -r 0 hostname)
echo SCHEDULER: $SCHEDULER_HOST

# Start the dask scheduler on the rank 0 task in the background
flux exec -r 0 dask-scheduler --port=8786 &
sleep 5

# Use flux run to start dask workers on all allocated nodes in the background
# One dask-worker command is run per node, which then starts 12 processes (--nprocs 12).
flux run -N ${FLUX_JOB_NNODES} --tasks-per-node=1 dask-worker --nprocs 12 --nthreads 1 $SCHEDULER_HOST:8786 &
sleep 5 # Give workers time to start and connect

# The main python script runs on the initial node (rank 0)
python benchmark_rms_distr.py /scratch/$USER/$FLUX_JOB_ID $SCHEDULER_HOST:8786
