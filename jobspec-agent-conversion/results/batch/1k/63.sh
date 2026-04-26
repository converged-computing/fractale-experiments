#!/bin/sh

#FLUX: --output=sim_param_opt.out-%j-%a

# NOTE: The %j and %a format specifiers are not supported in Flux; files will be overwritten.


# run with: sbatch jobArray.sh
# or run with: LLsub jobArray.sh

# Initialize Modules
source /etc/profile

# Load Julia Module
module load anaconda3-5.0.1

# NOTE: This script is a job array. The SLURM variables have been replaced
# with Flux variables. You must submit this job with 'flux submit --cc=1-4 ...'
TASK_COUNT=4
echo "My FLUX_JOB_CC: " $FLUX_JOB_CC
echo "Number of Tasks: " $TASK_COUNT

python3 language.py $FLUX_JOB_CC $TASK_COUNT
