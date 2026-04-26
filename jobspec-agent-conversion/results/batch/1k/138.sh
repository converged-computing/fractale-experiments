#!/bin/bash
#FLUX: --job-name=test_dataAnalysis
#FLUX: --time-limit=2h
#FLUX: --ntasks=1

module load matlab
matlab -nodisplay -nojvm -nosplash < MASSIVE_ANALYSIS_SM.m
