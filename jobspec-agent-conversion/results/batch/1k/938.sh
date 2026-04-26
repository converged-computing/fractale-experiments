#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --job-name=ffs_256
#FLUX: --time-limit=48h
#FLUX: --gpus-per-node=4
#FLUX: --requires=volta,volta32G
#FLUX: --output=/home/kpusteln/loads/tsm_base.txt

# The --account directive was ignored as per instructions.

# Load modules
module purge 2>&1 >/dev/null
module load \
  gpu/cuda/11.7 \
  common/git/2.27.0 \
  common/anaconda/3.8 \
  common/compilers/nvidia/21.2 \
  common/compilers/gcc/9.3.1

# Load Python env
cd /home/kpusteln/stylegan-v
conda activate ./env

# Run training
CC=gcc CXX=g++ \
python3 src/infra/launch.py \
  hydra.run.dir=. \
  exp_suffix=tsm_base \
  env=local \
  dataset=ffs \
  dataset.name=ffs_processed \
  dataset.resolution=256 \
  +ignore_uncommited_changes=true \
  +overwrite=True \
  num_gpus=4 \

