#!/bin/bash

# SMP Script for CANDIDE
# The original script requested a specific node ('n02'), which is not a portable request.
# This has been converted to a generic request for 1 node and 2 cores.

# Set a name for the job
#FLUX: --job-name=psfex_run_d4_shifts

# Set maximum computing time
#FLUX: --time-limit=4d3h

# Request number of cores
#FLUX: --nodes=1
#FLUX: --ntasks=2

# The PBS directive to join output and error files ('-j oe') has no direct analog.

# Activate conda environment
module load tensorflow/2.4
module load intel/19.0/2
source activate new_shapepipe

cd /home/tliaudat/github/wf-psf/

python ./method-comparison/scripts/psfex_script.py \
    --repo_base_path /home/tliaudat/github/wf-psf/ \
    --saving_dir /n05data/tliaudat/wf_exps/outputs/psfex_d4_shifts/ \
    --dataset_path /n05data/tliaudat/wf_exps/datasets/psfex_shifts/ \
    --psfvar_degrees 4 \
    --psf_sampling 1. \
    --psf_size 32 \
    --run_id psfex_run_r1_d4 \
    --exec_path psfex \
    --verbose 1 \

# Return exit code
exit 0
