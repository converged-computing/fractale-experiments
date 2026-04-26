#!/bin/bash 

#FLUX: --job-name=auto_encoder_type1
# The --partition=Hercules directive is ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --ntasks=4
# The --mem-per-cpu=16G directive has no direct flux analog and is omitted.
# The --gres=gpu:TitanV:1 directive is translated to a gpu count and a constraint.
#FLUX: --gpus-per-node=1
#FLUX: --requires=TitanV
#FLUX: --time-limit=24h


module load pytorch/1.6.0-anaconda3-cuda10.2

pip install --no-index --upgrade pip

conda install -c akode atari-py  

python Type_1.py
