#!/bin/bash 

#FLUX: --job-name=auto_encoder_type1
#FLUX: --queue=Hercules
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --gpus-per-node=1
#FLUX: --requires=TitanV
#FLUX: --time-limit=24h

# The --mem-per-cpu=16G parameter (total 64GB) has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.


module load pytorch/1.6.0-anaconda3-cuda10.2

pip install --no-index --upgrade pip

conda install -c akode atari-py  

python Type_1.py
