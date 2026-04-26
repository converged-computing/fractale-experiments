#!/bin/sh
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=400h
#FLUX: --cc=1-100
#FLUX: --cwd=.

# Load Modules:
#  1) R/3.5.0   2) r-biomed-libs/3.5.0

# -t is array parameter, the same job will be submitted the length of the input,
# each with its own unique array id ($FLUX_JOB_CC)


flux resource list -o hosts
# qstat -f $FLUX_JOB_ID # No direct equivalent for qstat -f


# vector index starts at 0 so shift array by one

seed=$(($FLUX_JOB_CC - 1))

# print out which model is being run in each job

echo Using "Random Forest"

# Using $FLUX_JOB_CC to select parameter set

#Rscript code/learning/main.R $seed "Random_Forest"
make data/temp/best_hp_results_Random_Forest_$seed.csv

echo "Script complete"
echo "qsub working directory absolute is"
echo .
# qstat -f $FLUX_JOB_ID # No direct equivalent for qstat -f
exit

