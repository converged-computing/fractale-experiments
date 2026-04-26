#!/bin/sh
#FLUX: --cores-per-task=1
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --time-limit=24h
#FLUX: --output=job.out
#FLUX: --cc=1-100

SEED=$((${FLUX_JOB_CC}))
echo $SEED

make processed_data/rf_genus_$SEED.Rds

