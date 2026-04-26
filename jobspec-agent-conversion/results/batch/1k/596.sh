#!/bin/bash

#FLUX: --job-name=fc_sn
#FLUX: --time-limit=24h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=24
#FLUX: --begin-time=now

module load python/3.8
source activate coop
export LD_LIBRARY_PATH=/home/dcas/g.angelotti/.conda/envs/coop/lib:$LD_LIBRARY_PATH

python -W ignore main.py --exact 15 --full 1 --sim_num 72 --pol_a smart --pol_b nothing
