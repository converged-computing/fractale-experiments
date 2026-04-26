#!/bin/bash
#FLUX: --job-name=psfex_run_d4_shifts
#FLUX: --time-limit=99h
#FLUX: --nodes=1
#FLUX: --ntasks=2
#FLUX: --output=psfex_run_d4_shifts.out

# Activate conda environment
# module load intelpython/3-2020.1
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
