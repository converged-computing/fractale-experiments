#!/bin/bash
#FLUX: --time-limit=2h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4

# run models
for current_dataset in {1..10}
do
    singularity run -B /scratch,/m,/l,/share docker://andrjohns/stan-triton Rscript ./R/joint-predictive/joint-predictive-sample-beta.R $1 $current_dataset $2 $3
done
