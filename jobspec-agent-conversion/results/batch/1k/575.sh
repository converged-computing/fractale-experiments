#!/bin/bash
#FLUX: --job-name=matlab-svd
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
# The --mem-per-cpu=4G directive has no direct flux analog and is omitted.
#FLUX: --time-limit=2m
#FLUX: --gpus-per-task=1
# The --reservation=gpuprimer directive has no direct flux analog and is omitted.

module purge
module load matlab/R2019a

matlab -singleCompThread -nodisplay -nosplash -r svd_matlab
