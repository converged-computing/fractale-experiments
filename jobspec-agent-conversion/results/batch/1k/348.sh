#!/bin/sh

# The --partition=gpus directive is ignored as per instructions.

#FLUX: --time-limit=1m

#FLUX: --nodes=1

#FLUX: --ntasks-per-node=1

# The --mem=1000 directive has no direct flux analog and is omitted.

#FLUX: --error=job.%j.err

#FLUX: --output=job.%j.out

date

nvidia-smi 
