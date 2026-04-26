#!/bin/bash -l
#FLUX: --nodes=7
#FLUX: --time=5h
#FLUX: --job-name=dask_cluster
#FLUX: --ntasks=7
#FLUX: --cores-per-task=36

# Environment variables
export OMP_NUM_THREADS=$FLUX_JOB_NCORES
export MPLBACKEND="agg"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
 
# The original script used a complex, manual dask startup with srun.
# The modern and recommended approach is to use the `dask-flux` utility,
# which handles the setup of the scheduler and workers automatically within the allocation.
# We pass the allocated resources to dask-flux.

dask-flux --nworkers $((FLUX_JOB_NNODES - 1)) --nthreads 36 --scheduler-file $HOME/scheduler.json &

sleep 10 # Allow time for the cluster to start

# The final python script is then executed as the main task of the job.
python crsim_multidop_testing.py /home/rjackson/scheduler.json
