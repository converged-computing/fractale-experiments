#!/bin/bash

# Job Submission Options
# Name
#FLUX: --job-name=combine-d1-output

# Resources
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=5h

# Logs
# The dynamic filename from Slurm (%x-%j.out) is not supported.
# Using a static name based on the job name.
#FLUX: --output=combine-d1-output.out


# Job Commands
# Making output dir for snakemake cluster logs
mkdir -p logs/slurm/

bash code/bash/family_d1_cat_csv_files.sh
