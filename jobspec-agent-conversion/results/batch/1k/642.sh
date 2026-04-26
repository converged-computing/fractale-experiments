#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=10m
#FLUX: --output=job.out
#FLUX: --error=job.out

module load python/3.5.0

python elephant.py
