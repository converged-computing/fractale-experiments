#!/bin/bash

#SBATCH --time=24:00:00   # walltime
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --cores-per-task=5
#FLUX: --job-name="rs2a"


#FLUX: --output=rs2a-slurm.%N.%j.out
#FLUX: --error=rs2a-slurm.%N.%j.err

# NOTE: The %N and %j format specifiers are not supported in Flux; files will be overwritten.

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
python -u -c "import PyHipp as pyh; \
import DataProcessingTools as DPT; \
import os; \
import time; \
t0 = time.time(); \
print(time.localtime()); \
DPT.objects.processDirs(dirs=None, objtype=pyh.RPLSplit, channel=[*range(33,65)], SkipHPC=False, HPCScriptsDir='/data/src/PyHipp/', SkipLFP=False, SkipHighPass=False, SkipSort=False); \
print(time.localtime()); \
print(time.time()-t0);"

aws sns publish --topic-arn arn:aws:sns:ap-southeast-1:278160482529:awsnotify --message "RPLS2JobDone"
