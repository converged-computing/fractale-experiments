#!/bin/bash
#FLUX: --job-name=field_imnn
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=3h
#FLUX: --cc=1-4

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.
# The --gres parameter for a specific GPU type is not supported; only the count is used.

module load  gcc/7.4.0 cuda/10.1.243_418.87.00 cudnn/v7.6.2-cuda-10.1 nccl/2.4.2-cuda-10.1 python3/3.7.3

source ~/anaconda3/bin/activate pyimnn

# Create the output directory if it doesn't exist
mkdir -p ./slurmscripts

# Manually redirecting output to replicate slurm's %A_%a behavior
python3 field_run.py $FLUX_JOB_CC > ./slurmscripts/job_${FLUX_JOB_ID}_${FLUX_JOB_CC}.out 2>&1
