#!/bin/bash
#FLUX: --job-name=copy_methane4
#FLUX: --ntasks=1
# The --mem=1gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=24h5m
#FLUX: --output=parallel_%j.log

. /home/rs/anaconda3/etc/profile.d/conda.sh
conda activate mosdef-study38

rsync -av /home/rs/space/projects/final_repro_methane/reproducibility_study/reproducibility_project/methane_systemsize_subproject4/* .
