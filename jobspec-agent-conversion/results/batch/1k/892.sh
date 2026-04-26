#!/bin/sh
#FLUX: --job-name=neumann
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --time-limit=24h
#FLUX: --output=../data/pinn/logs/Output_{id}.txt
#FLUX: --error=../data/pinn/logs/Error_{id}.txt

module load python3/3.8.9
module load cuda/11.1
module load cudnn/v8.0.4.30-prod-cuda-11.1
module load tensorrt/7.2.3.4-cuda-11.1

export PYTHONPATH="${PYTHONPATH}:/zhome/00/4/50173/.local/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$CUDA_ROOT/extras/CUPTI/lib64/"

python3 main_train.py --path_settings="scripts/settings/neumann_1D.json"
