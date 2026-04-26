#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --exclusive
#FLUX: --cores-per-task=10
#FLUX: --time-limit=1d
#FLUX: --rlimit=vmem=unlimited
#FLUX: --rlimit=stack=unlimited
#FLUX: --rlimit=nproc=10000


# -- load from available modules
module load matlab/R2018a
# -- change directory where my_job.m is.
#    this variable is defined in steady_.sh
job_path="../../$job_name/scripts/"
cd $job_path
# -- run job
matlab -nodisplay -nodesktop -r "run ./dc_link__.m ; quit"

