#!/bin/bash

#FLUX: --job-name=wmt-en2de
#FLUX: --output=./logfiles/logfile_wmt.out
#FLUX: --error=./logfiles/logfile_wmt.err
#FLUX: --time-limit=70h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=4
#FLUX: --cores-per-task=40
#FLUX: --requires=v100-32g

# The --hint=nomultithread directive has no direct analog in the provided flux submit options.
# This may impact job performance.

module purge
module load anaconda-py3/2019.03
conda activate lmvsseq2seq
set -x
nvidia-smi
# This will create a config file on your server

accelerate launch --multi_gpu train_enc_dec_mp.py --train=True --test=True
