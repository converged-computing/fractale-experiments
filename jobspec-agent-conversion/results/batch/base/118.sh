#!/bin/bash

###############################
#                             #
#  1) Job Submission Options  #
#                             #
###############################

# Name
#FLUX: --job-name=combine-d1-output

# Resources
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: -t 5h
# NOTE: The Slurm directive '--mem-per-cpu=250m' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

# Account
#FLUX: -B pschloss1
#FLUX: -q standard
# NOTE: The SLURM account and partition directives were mapped to Flux bank and queue.

# Logs
#FLUX: --output={flux:jobname}-{flux:jobid}.out
# NOTE: The Slurm directives for email notification ('--mail-user', '--mail-type') were omitted as there are no direct Flux equivalents.

# Environment
# NOTE: The Slurm directive '--export=ALL' is the default behavior in Flux and was omitted.

#####################
#                   #
#  2) Job Commands  #
#                   #
#####################

# Making output dir for snakemake cluster logs
mkdir -p logs/slurm/

bash code/bash/family_d1_cat_csv_files.sh

