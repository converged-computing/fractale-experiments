#!/bin/bash
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --output=logs/job_%J.out
#FLUX: --error=logs/job_%J.log

# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.


source /ccs/proj/bif138/env.sh

module load bzip2 r/4.0.5

conda activate my-opence-ray





# 'jsrun' is replaced by 'flux run'. Resource requests are now in the directives.
flux run -n 1 --gpus-per-task=6 --cores-per-task=42 bash 2_validate_and_select_best.sh $mdir $input
