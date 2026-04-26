#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --job-name=phaseshift
#FLUX: --cc=0-410
#FLUX: --requires=amd
#FLUX: --time-limit=10h

#SINGULARITY
SING_BIND=$( python3 $HOME/parse_settings.py --BIND )
SIMG=$( python3 $HOME/parse_settings.py --SIMG )

echo "Job landed on $(hostname)"

pattern="*MHz*.parset"
files=( $pattern )
N=$(( ${FLUX_JOB_CC} ))

#RUN
singularity exec -B $SING_BIND $SIMG DP3 ${files[${N}]}
echo "Launched script for ${files[${N}]}"
