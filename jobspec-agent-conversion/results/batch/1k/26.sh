#!/bin/bash
#FLUX: -t 1d
#FLUX: -g 1
#FLUX: -c 4
#FLUX: -n 1

# The SLURM directive '--mem-per-cpu=4G' was omitted as it has no direct Flux translation.

module load python/3.8
source /home/mila/c/chris.emezue/scratch/py38env/bin/activate
export CUDA_VISIBLE_DEVICES=0

python3 get_all_orientations_dag.py
