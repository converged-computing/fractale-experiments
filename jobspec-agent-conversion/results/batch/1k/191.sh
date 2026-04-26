#!/usr/bin/env bash
#FLUX: --job-name=jobname
#FLUX: --nodes=1
#FLUX: --ntasks=20
#FLUX: --time-limit=4h10m
#FLUX: --output=stdout
#FLUX: --error=stderr


module purge
module load intel/2017b GPAW/1.3.0-Python-2.7.14

export GPAW_SETUP_PATH=$GPAW_SETUP_PATH:/c3se/apps/Glenn/gpaw/gpaw-setups-0.9.11271/
export GPAW_SETUP_PATH=$GPAW_SETUP_PATH:./

# 'mpirun' is replaced with 'flux run'
flux run -n 20 gpaw-python ./HA3_4.py
