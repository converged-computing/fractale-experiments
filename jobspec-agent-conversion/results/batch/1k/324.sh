#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

set -e

MODULE="TensorFlow/2.11.0-foss-2022a-CUDA-11.7.0"
me=$(basename $0)
rootpath=$(dirname $0)

echo "${me}: Running beginner example with ${MODULE}"
ml ${MODULE}

python ${rootpath}/beginner.py
echo "${me}: Script exited with code $?"
