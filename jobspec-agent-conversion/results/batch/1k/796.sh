#!/bin/bash

# DO NOT CHANGE THE QUEUE! YOU **MUST** ONLY USE THE QUEUE: short_serial
# The -q (queue) and -u (mail-user) directives are ignored.

# THE JOB ARRAY:
# The LSF job array directive `-J "...[1-10]"` is replaced by the --cc flag at submission time.
# This script should be submitted with: flux submit --cc=1-10 your_script_name.sh
#FLUX: --job-name=process_reuters_lda_data_train

# THE COMMAND TO GIVE TO R, CHANGE TO THE APPROPRIATE FILENAME:
partition=train
cutoff=500

# The LSB_JOBINDEX variable is replaced with FLUX_JOB_CC for job arrays
main_dir=/n/airoldifs2/lab/jbischof/reuters_output/mmm_folds/fold${FLUX_JOB_CC}/
out_dir=${main_dir}mmm_raw_data/parsed_${partition}_data${cutoff}/

# Create partition directory if doesn't already exist
if [ ! -d $out_dir ]
then
   mkdir $out_dir
fi

# Run python script
python ../process_parse_lda_data.py $partition $cutoff $main_dir
