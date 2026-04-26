#!/bin/bash
#FLUX: --cc=1
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=4d
#FLUX: --output=Output_Eval.out

module load python/3.9.0
module load cuda/11.3.1
module load cudnn/8.2.0
source ~/envs/DynG2G/bin/activate
python3 -u Eval.py -f configs/config-1.yaml
