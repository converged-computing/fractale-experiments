#!/bin/bash
#FLUX: --job-name=evaluation_open
#FLUX: --output=/home/timothy.walsh/VF/3_open_world_baseline/%x.out
#FLUX: --cores-per-task=2
#FLUX: --gpus-per-task=1
#FLUX: --requires=rtx6000
#FLUX: --time-limit=24h

# The --mem=64GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job name substitution (%x).

source /share/spack/gcc-7.2.0/miniconda3-4.5.12-gkh/bin/activate /share/spack/gcc-7.2.0/miniconda3-4.5.12-gkh/envs/tflow
python3 /home/timothy.walsh/VF/3_open_world_baseline/evaluation_open.py
