#!/bin/sh
#FLUX: --job-name=PWdata
#FLUX: --cc=1-30
#FLUX: --ntasks=1
#FLUX: --time-limit=16h
#FLUX: --nodes=1
#FLUX: --output=../log/log.out
#FLUX: --error=../log/log.err

source /work3/xenoka/miniconda3/bin/activate pytorch

python3 PlaneWaveArrays.py --lsf_index $FLUX_JOB_CC --init_n_mics 100 --radius 0.5

