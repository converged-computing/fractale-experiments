#!/bin/bash

#FLUX: --job-name=cp
#FLUX: --time-limit=100m
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1


date

source /opt/easybuild/software/Anaconda3/2019.07/etc/profile.d/conda.sh
conda init bash
conda activate tasks-pip

rm -r tmp_out
python run_example_cellpose.py

date

