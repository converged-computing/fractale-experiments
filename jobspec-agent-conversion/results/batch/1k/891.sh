#!/bin/bash

#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --job-name=Lshape3D_eval
#FLUX: --output="/work3/nibor/data/logs/deeponet_Lshape3D_%J.out"
#FLUX: --error="/work3/nibor/data/logs/deeponet_Lshape3D_%J.err"


export PYTHONPATH="${PYTHONPATH}:/zhome/00/4/50173/.local/bin"

module load python3/3.10.7
module load cuda/12.1.1
module load cudnn/v8.9.1.23-prod-cuda-12.X
module load tensorrt/8.6.1.6-cuda-12.X 

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$CUDA_ROOT/extras/CUPTI/lib64/"

python3 main3D_eval.py --path_settings="scripts/threeD/setups/Lshape.json" --path_eval_settings="scripts/threeD/setups/Lshape_eval.json"
