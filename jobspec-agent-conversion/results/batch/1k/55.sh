#!/bin/bash

#FLUX: --time-limit=1d
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name=smp-TARGET-cormorant

module load gcc/8.1.0
module load cuda/10.0
source /home/users/mvoegele/miniconda3/etc/profile.d/conda.sh
conda activate cormorant

echo $CUDA_HOME

LMDBDIR=/oak/stanford/groups/rondror/projects/atom3d/lmdb/SMP/splits/random/data/

python train.py --target TARGET --prefix smp-TARGET --load \
                --datadir $LMDBDIR --format lmdb --num-epoch 150
