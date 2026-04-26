#!/bin/sh
### General options
#FLUX: --job-name=csgm_inference
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d
#FLUX: --output=../../log/log-%J-%I.out
#FLUX: --error=../../log/log-%J-%I.err

# NOTE: The %J and %I format specifiers are not supported in Flux; files will be overwritten.


source /work3/xenoka/miniconda3/bin/activate pytorch

python run_CSGM.py --get_metrics --adaptive_gan
