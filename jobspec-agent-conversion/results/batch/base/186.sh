#!/bin/bash
#FLUX: --job-name=copy_methane4
#FLUX: --ntasks=1
#FLUX: --time-limit=24h5m
#FLUX: --output=parallel_{id}.log

# The --mem=1gb parameter from slurm has no direct equivalent in flux-submit.
# The job will run with the system's default memory allocation.

. /home/rs/anaconda3/etc/profile.d/conda.sh
conda activate mosdef-study38

rsync -av /home/rs/space/projects/final_repro_methane/reproducibility_study/reproducibility_project/methane_systemsize_subproject4/* .
