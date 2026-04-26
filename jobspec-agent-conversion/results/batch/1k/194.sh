#!/bin/bash

#FLUX: --job-name=table
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --output=slurm/table-gustySides-%j.out



# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

cd /mnt/personal/sykorvo1/PPOthesis/ppo
# singularity run --bind /mnt/personal/sykorvo1:/mnt/personal/sykorvo1 --nv tensorflow_2.10.0-gpu.sif

# conda activate newest
python run_model.py --load_model BEST/gustySides/ep780_4to5
