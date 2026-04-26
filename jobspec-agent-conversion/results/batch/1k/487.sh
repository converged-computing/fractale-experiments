#!/bin/bash
#FLUX: --begin=now
#FLUX: --time-limit=3h
#FLUX: --cc=0-1:1
#FLUX: --cores-per-task=1
#FLUX: --ntasks=48
#FLUX: --tasks-per-node=48
#FLUX: --nodes=1
#FLUX: --output=/project/def-jemerson/chbank/16_07_2020_18_16_04/results/ouptut.o
#FLUX: --error=/project/def-jemerson/chbank/16_07_2020_18_16_04/results/errors.o
#FLUX: --cwd=/project/def-jemerson/a77jain/chflow


module load intel/2016.4 python/3.7.0 scipy-stack/2019a
./chflow.sh 16_07_2020_18_16_04 ${FLUX_JOB_CC}

