#!/bin/bash
#FLUX: --job-name=yg390
#FLUX: --time-limit=2h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --nodes=1
#FLUX: --gpus-per-task=2
#FLUX: --output=distilling_batch.log



module purge
module load python3/intel/3.6.3
source ~/distiller/env/bin/activate

python3 src/many_lstms_main.py
