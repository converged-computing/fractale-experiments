#!/bin/bash
#FLUX: --job-name=CUDA_Run_base_1
#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --gpus-per-task=2
#FLUX: --cores-per-task=24
#FLUX: --exclusive
#FLUX: --output=log.cb1.slurm-%A_%a.out
#FLUX: --error=err.cb1.slurm-%A_%a.out

set -x

# only use on GPU
export CUDA_VISIBLE_DEVICES=0

# load modules
export alpaka_DIR=/home/schenk24/workspace/alpaka/
module load git gcc cmake cuda boost python

cd build_cuda_1
# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-9 ...'
python ../run_base.py $FLUX_JOB_CC
