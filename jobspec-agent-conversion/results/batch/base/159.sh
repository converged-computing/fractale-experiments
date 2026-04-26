#!/bin/bash

# DO NOT CHANGE THE QUEUE! YOU **MUST** ONLY USE THE QUEUE: short_serial
#FLUX: --queue=airoldi

# The LSF email notification option (-u) has no direct equivalent in flux-submit.

# THE JOB ARRAY:
#FLUX: --job-name=process_reuters_lda_data_train
#FLUX: --cc=1-10

# THE COMMAND TO GIVE TO R, CHANGE TO THE APPROPRIATE FILENAME:
partition=train
cutoff=500

# The LSF environment variable LSB_JOBINDEX has been replaced with FLUX_JOB_CC
main_dir=/n/airoldifs2/lab/jbischof/reuters_output/mmm_folds/fold${FLUX_JOB_CC}/
out_dir=${main_dir}mmm_raw_data/parsed_${partition}_data${cutoff}/

# Create partition directory if doesn't already exist
if [ ! -d $out_dir ]
then
   mkdir $out_dir
fi

# Run python script
python ../process_parse_lda_data.py $partition $cutoff $main_dir
