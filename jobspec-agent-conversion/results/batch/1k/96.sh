#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=11h50m
#FLUX: --output=/home/shaws5/projects/def-beckers/shaws5/Research_code/EEGnet/Sharcnet/out_files/processLOO_AmyTasks.out
#FLUX: --cwd=/home/shaws5/projects/def-beckers/shaws5/Research_code/EEGnet/Main

module load matlab
matlab -nodesktop -nosplash -nodisplay -r "run('processLOO_AmyTasks.m'); exit"

