#!/bin/bash

#FLUX: --job-name=mccd_SR_id09
#FLUX: --time-limit=99h
#FLUX: --nodes=1
#FLUX: --cores=4
#FLUX: --gpus-per-node=1
#FLUX: --requires=n03,hasgpu

# The -j oe directive (join stdout/stderr) has no direct analog in Flux.
# The -M and -m mail directives were ignored as per instructions.

# Activate conda environment
# module load intelpython/3-2020.1
module load tensorflow/2.4
module load intel/19.0/2
source activate new_shapepipe

cd /home/tliaudat/github/wf-psf/method-comparison/scripts/

python ./mccd_script_SR.py \
    --config_file /home/tliaudat/github/wf-psf/method-comparison/config_files/mccd_configs/config_MCCD_SR_wf_exp_id09.ini \
    --repo_base_path /home/tliaudat/github/wf-psf/ \
    --run_id mccd_SR_id09 \
    --psf_out_dim 64 \


# Return exit code
exit 0
