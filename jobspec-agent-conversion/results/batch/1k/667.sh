#!/bin/bash
 
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d12h
#FLUX: --cores-per-task=3



module load palma/2021b
module load Singularity
module load CUDA/11.6.0


singularity run --nv --bind .:/code open3d.sif train_essen.py "$1"
