#!/bin/bash
#FLUX: --job-name=Summary
#FLUX: --time-limit=24h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=9
#FLUX: --gpus-per-task=1
#FLUX: --input=summaryAcrossPix.m

module load matlab
matlab -nodisplay -nodesktop -nosplash
