#!/bin/bash
#FLUX: --job-name=matlab-svd
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2m
#FLUX: --gpus-per-task=1

# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.
# The SLURM --reservation directive has no direct Flux analog.

module purge
module load matlab/R2019a

matlab -singleCompThread -nodisplay -nosplash -r svd_matlab
