#!/bin/bash
#FLUX: --job-name=ethane_NaCl_0.50_Reference
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=36
#FLUX: --gpus-per-task=2
#FLUX: --error=run.err
#FLUX: --output=run.out

source ~/.bashrc
source ~/.bash_profile

cd /data4/stefan/Cavity-Formation/Simulations/ethane/NaCl/0.50

export CUDA_VISIBLE_DEVICES="0,1"

python openMM.py
