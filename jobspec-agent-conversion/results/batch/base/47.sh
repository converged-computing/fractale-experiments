#!/bin/bash
#FLUX: --job-name=bead-select
#FLUX: --ntasks=1
#FLUX: --time-limit=100h
#FLUX: --queue=WitsLong
#FLUX: --cc=0-1024

# The PBS parameter 'mem=7GB' has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.

hostname

cd  /spaces/scott/chip/pool_selection/

# The PBS_ARRAYID variable is replaced by FLUX_JOB_CC
run=${FLUX_JOB_CC}

/usr/bin/time  python pool_select.py --input all.cpickle --label S${LABEL} --bad badscore60.lst --requests extra.lst,req_func_u.scores --factor 1.5 $run 10 18
