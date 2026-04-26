#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=7d
#FLUX: --job-name='td_dynamic'
#FLUX: --output=td_dynamic_%a.out
#FLUX: --error=td_dynamic_%a.err

# NOTE: The %a format specifier is not supported in Flux; files will be overwritten.

IDFILE=$APPS"/prospector_alpha/data/3dhst/td_dynamic.ids"
# NOTE: $SLURM_ARRAY_TASK_ID is replaced by $FLUX_JOB_CC, which is set by flux submit --cc
OBJID=$(sed -n "${FLUX_JOB_CC}p" "$IDFILE")

# srun is not required for a single task job in Flux
python $APPS/prospector/scripts/prospector_dynesty.py \
--param_file="$APPS"/prospector_alpha/parameter_files/td_dynamic_params.py \
--objname="$OBJID" \
--outfile="$APPS"/prospector_alpha/results/td_dynamic/"$OBJID" \
--runname="td_dynamic"
