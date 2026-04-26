#!/bin/bash 
#FLUX: --job-name=pd
#FLUX: --time-limit=60h
#FLUX: --nodes=8
#FLUX: --tasks-per-node=64
#FLUX: --output=/home/salvadord/pd/data/pd_scale-1.0_DC-0_TH-0_Balanced-1_1sec_512.run
#FLUX: --error=/home/salvadord/pd/data/pd_scale-1.0_DC-0_TH-0_Balanced-1_1sec_512.err

source ~/.bashrc
cd /home/salvadord/pd
flux mini run -n 512 nrniv -python -mpi init.py
wait
