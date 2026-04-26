#!/usr/bin/env bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=12h

# The --mem=20GB parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.

module load pytorch/1.4.0-py36-cuda90
module load torchvision/0.5.0-py36

#pip install geoopt
#pip install git+https://github.com/geoopt/geoopt.git
python3 pvae/main.py --model mnist --manifold PoincareBall --c 0.1  --latent-dim 40 --hidden-dim 600 --prior WrappedNormal --posterior WrappedNormal --dec Geo     --enc Wrapped --lr 5e-4 --epochs 80 --save-freq 80 --batch-size 128 --iwae-samples 5000
