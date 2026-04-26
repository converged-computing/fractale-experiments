#!/bin/bash -l
#
#FLUX: --job-name="sed2ds"
#FLUX: --time-limit=23h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=4




module load 2022r1
module load gpu
module load python/3.8.12-bohr45d
module load openmpi
module load py-tensorflow




# srun is not required for a single task job in Flux
python Model2D_SEDENTARY_SUBJ.py
