#!/bin/bash
#FLUX: --time-limit=24h
#FLUX: --ntasks=512
#FLUX: --nodes=16
#FLUX: --job-name=marin
#FLUX: --cwd=.

# nnodes = ncpus/32
source /opt/modules/default/etc/modules.sh
source ${PROTEUS}/envConfig/garnet.gnu.bash
mkdir $WORKDIR/marin.$FLUX_JOB_ID
# n = N*nnodes = N*ncpus/32
#flux run -n 512 parun marin_so.py -l 7 -v --cacheArchive -O petsc.options --profile -D $WORKDIR/marin.$FLUX_JOB_ID
flux run -n 256 --tasks-per-node=16 parun marin_so.py -M 3.875 -l 7 -v -O ../inputTemplates/petsc.options.schur_upper_a11_asm_boomeramg -D $WORKDIR/marin.$FLUX_JOB_ID

