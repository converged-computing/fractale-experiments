#!/bin/bash
#
#FLUX: --job-name=TravailGPU
# The -C v100-32g directive is translated to the following RFC 35 constraint:
#FLUX: --requires=v100-32g
#FLUX: --output=TravailGPU%j.out
#FLUX: --error=TravailGPU%j.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=10
# The --hint=nomultithread directive has no direct flux analog and is omitted.
# Flux can control affinity with, e.g., -o cpu-affinity=per-task
#FLUX: --time-limit=20h

module purge 
module load pytorch-gpu/py3/1.10.1 
python -u train_gym.py 
