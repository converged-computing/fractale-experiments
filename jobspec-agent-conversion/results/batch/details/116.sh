#!/bin/bash
#FLUX: --job-name=array-job
# The Slurm output pattern %A.%a is not supported. Using %j for the job collection ID.
# Note: All tasks in the job collection will write to the same output files.
#FLUX: --output=flux-%j.out
#FLUX: --error=flux-%j.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
# The --mem-per-cpu=4G directive has no direct flux analog and is omitted.
#FLUX: --time-limit=1m
# The Slurm --array directive is replaced by the --cc flag at submission time.
# This script should be submitted with: flux submit --cc=0-2 your_script_name.sh

# SLURM_ARRAY_JOB_ID is equivalent to FLUX_JOB_ID for the collection.
# SLURM_ARRAY_TASK_ID is equivalent to FLUX_JOB_CC.
echo "My FLUX_JOB_ID is $FLUX_JOB_ID."
echo "My FLUX_JOB_CC is $FLUX_JOB_CC"
echo "Executing on the machine:" $(hostname)

module purge
module load anaconda3/2023.9

python myscript.py
