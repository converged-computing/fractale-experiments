#!/bin/bash
#FLUX: --job-name=resnet_multi_ncl_1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=7d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --output=%x_%j_output.log
#FLUX: --error=%x_%j_error.log

# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.


source /etc/profile.d/conda.sh
conda activate ecapa_tdnn

python3 trainRESNETModelMulti_ncl_1.py

conda deactivate
