#!/bin/bash

##########################
# Converted SMP Script for Flux #
##########################

#FLUX: --job-name=mccd_data_gen
#FLUX: -t 99h
#FLUX: -n 1
#FLUX: -c 2

# The PBS directive for a specific node ('n16') was omitted as it has no direct generic Flux translation.
# The PBS directive to join output/error files ('-j oe') has no direct Flux translation and was omitted.
# Mail directives were ignored as per instructions.

# Activate conda environment
# module load intelpython/3-2020.1
module load tensorflow/2.4
module load intel/19.0/2
source activate new_shapepipe

cd /home/tliaudat/github/wf-psf/

python ./method-comparison/scripts/dataset-conversion-MCCD.py \
    --rca_data_path /n05data/tliaudat/wf_exps/datasets/rca/ \
    --mccd_saving_path /n05data/tliaudat/wf_exps/datasets/mccd/ \


# Return exit code
exit 0
