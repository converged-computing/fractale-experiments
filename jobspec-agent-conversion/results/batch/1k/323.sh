#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16 
#FLUX: --time-limit=4h
#FLUX: --job-name=34046
#FLUX: --output=34046.out

source ../venvs/hammer/bin/activate

module load python/intel/3.8.6
module load openmpi/intel/4.0.5
time python3 hammer-run.py  --envname cn --config configs/cn.yaml --nagents 3 --dru_toggle 0 --meslen 2 --randomseed 34046
