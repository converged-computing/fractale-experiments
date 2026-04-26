#!/bin/bash

#FLUX: --job-name=ImProc_4x
#FLUX: --time-limit=2h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cc=0-999

python batch.py $FLUX_JOB_CC
