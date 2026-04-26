#!/bin/bash
#FLUX: --job-name=isochrones
#FLUX: --output=isochrones.o%j
#FLUX: --error=isochrones.e%j
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=4h

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/home/apricewhelan/software/lib/
cd /mnt/ceph/users/apricewhelan/projects/dr2-lmc-cluster/scripts

module load gcc openmpi2

date

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-418 ...'
python run_isochrones_sample.py --index=$FLUX_JOB_CC

date
