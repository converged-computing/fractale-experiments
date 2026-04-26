#!/bin/sh 
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=4d4h


# -t is array parameter, the same job will be submitted the length of the input,
# each with its own unique array id ($PBS_ARRAYID)


# cat $PBS_NODEFILE # PBS-specific command removed
# qstat -f $FLUX_JOB_ID # qstat is a PBS command

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

# vector index starts at 0 so shift array by one

# NOTE: This script is a job array. The PBS_ARRAYID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-100 ...'
seed=$(($FLUX_JOB_CC - 1))

# print out which model is being run in each job

echo Using "Decision Tree"

# Using $PBS_ARRAYID to select parameter set

make data/temp/best_hp_results_Decision_Tree_$seed.csv
#Rscript code/learning/main.R $seed "Decision_Tree"


echo "Script complete"
echo "Submission working directory absolute is"
echo $(pwd)
# qstat -f $FLUX_JOB_ID # qstat is a PBS command
exit
