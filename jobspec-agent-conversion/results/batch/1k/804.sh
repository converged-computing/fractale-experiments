#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=5m
#FLUX: --job-name=GPU_test_job

# The PBS generic GPU request (:nvidia) was translated to --gpus-per-node=1.
# PBS's dynamic output filename and stdout/stderr joining are not supported in Flux headers.
# Redirecting in the script body instead using the FLUX_JOB_ID variable.
exec > output${FLUX_JOB_ID}.log 2>&1

# Print the time and date
date
hostname
 
# $PBS_O_WORKDIR is the directory from where you submitted the job
# The Flux equivalent is $FLUX_SUBMIT_DIR
cd $FLUX_SUBMIT_DIR
 
# load cuda module
#. /usr/local/modules/init/bash

module load cuda
#time ~/CudaSamples/bin/x86_64/linux/release/deviceQuery
#time ~/CudaSamples/bin/x86_64/linux/release/deviceQuery
#~/CudaSamples/bin/x86_64/linux/release/clock

echo ./${program}
echo ./$program

time ./${program} ${args}
