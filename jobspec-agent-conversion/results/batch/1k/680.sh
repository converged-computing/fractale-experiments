#!/bin/bash -l
#FLUX: --ntasks=1
#FLUX: --exclusive
#FLUX: --cores-per-task=28
#FLUX: --time-limit=11h59m
#FLUX: --nodes=1

# -- set memory limits
ulimit -v unlimited
ulimit -s unlimited
ulimit -u 10000
# -- load from available modules
module load Apps/Matlab/R2020a
# -- change directory where my_job.m is.
#    this variable is defined in steady_.sh
job_path="../../$job_name/scripts/"
cd $job_path
# -- run job
matlab -nosplash -nodesktop -r "run ./dc_link_light_.m ;"
