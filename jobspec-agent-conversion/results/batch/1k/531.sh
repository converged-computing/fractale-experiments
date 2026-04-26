#!/bin/bash

#FLUX: --job-name=resnet_ple
#FLUX: --error=output/resnet_ple-%j.err
#FLUX: --output=output/resnet_ple.log

#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=3h20m


# NOTE: The %j format specifier is not supported in Flux; the error file will be overwritten.

module purge
module load Python

deactivate
source activate venv

pip install -r requirements.txt

export PYTHONPATH=$(pwd)

for _ in $(seq 1 5); do
    python -u src/train.py --experiment resnet_ple
done
