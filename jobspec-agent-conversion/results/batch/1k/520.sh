#!/usr/bin/env bash
#FLUX: --time-limit=59m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --cc=1-10

source ~/.bash_functions
mod_py39
source activate eso

NARRAY=10
NCHUNK=$((365 / $NARRAY))
dstart=$((1 + ($FLUX_JOB_CC - 1) * ($NCHUNK+1)))
dend=$(($dstart + $NCHUNK))
if [[ $dend -gt 365 ]]; then
  dend=365
fi
echo "Processing DOYs $dstart to $dend"

doys=$(seq $dstart $dend)

for d in $doys; do
  echo "Processing DOY $d"
  python kerchunk-dask-byhand.py --year=2022 --doy=$d
done
