#!/bin/bash -ex

#FLUX: --nodes=1
#FLUX: --ntasks=8
#FLUX: --time-limit=7d
#FLUX: --job-name=PaiNN-training
#FLUX: --output=runner_output.log
#FLUX: --gpus-per-node=1
#FLUX: --rlimit=stack=unlimited


#module load ASE/3.22.0-intel-2020b
#module load Python/3.8.6-GCCcore-10.2.0

export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

nvidia-smi > gpu_info
python3 md_run.py

