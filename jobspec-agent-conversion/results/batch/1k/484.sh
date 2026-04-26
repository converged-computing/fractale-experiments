#!/bin/bash -l
 
# Slurm parameters translated to Flux
#FLUX: --job-name=t11_wb
#FLUX: --output=dr_tune-%j.%N.out
#FLUX: -t 1d
#FLUX: -g 1
#FLUX: -n 1

# The SLURM directive '--mem=16G' was omitted as it has no direct Flux translation.
# The filename substitutions %j and %N are not supported by Flux and will be treated literally.
 
# Activate everything you need
module load cuda/11.2
# Run your python code
python3 wandb-tune.py
