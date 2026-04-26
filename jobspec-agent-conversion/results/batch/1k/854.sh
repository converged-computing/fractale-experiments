#!/bin/bash
#FLUX: --job-name=train_open_dschuster16_tor
#FLUX: --output=/home/timothy.walsh/VF/3_open_world_baseline/train_open_dschuster16_tor.out
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h

source /share/spack/gcc-7.2.0/miniconda3-4.5.12-gkh/bin/activate /share/spack/gcc-7.2.0/miniconda3-4.5.12-gkh/envs/tflow
python3 /home/timothy.walsh/VF/3_open_world_baseline/train_open.py

