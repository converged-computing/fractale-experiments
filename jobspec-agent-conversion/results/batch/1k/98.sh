#!/bin/bash

#Submit this script with: sbatch thefilename

#FLUX: --time-limit=1d
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --job-name="rse"


#FLUX: --output=rse-slurm.%N.%j.out
#FLUX: --error=rse-slurm.%N.%j.err

# NOTE: The %N and %j format specifiers are not supported in Flux; files will be overwritten.

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
python -u -c "import PyHipp as pyh; import DataProcessingTools as DPT; import time; import os; t0 = time.time(); print(time.localtime()); os.chdir('sessioneye'); pyh.RPLSplit(SkipLFP=False, SkipHighPass=False); print(time.localtime()); print(time.time()-t0);"
aws sns publish --topic-arn arn:aws:sns:ap-southeast-1:532875939626:awsnotify --message "RSEJobDone"
